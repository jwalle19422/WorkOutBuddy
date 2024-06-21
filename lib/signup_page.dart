import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:workout_buddy/utils/utils.dart';

import 'main.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  var utilsInstance = Utils();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final userNameTextController = TextEditingController();
  final aboutMeTextController = TextEditingController();
  final activityTextController = TextEditingController();
  final locationTextController = TextEditingController();
  final birthDateTextController = TextEditingController();

  //workout times
  bool isMorning = false;
  bool isNoon = false;
  bool isEvening = false;

  // date picker
  DateTime initDate = DateTime(2022, 01, 01);
  DateTime firstDate = DateTime(1900, 01, 01);
  DateTime lastDate = DateTime(2030, 01, 01);
  DateTime? birthDate;
  int? userAge;

  //location
  final Location location = Location();

  LocationData? _location;

  List<String> activityList = [];
  List<String> workoutTimesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: emailTextController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                    )),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      controller: passwordTextController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? 'Enter min. 6 characters'
                          : null,
                    )),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(),
                      ),
                      controller: confirmPasswordTextController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value != passwordTextController.text
                          ? 'Passwords don\'t match'
                          : null,
                    )),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 350,
                  child: TextFormField(
                    controller: birthDateTextController,
                    decoration: const InputDecoration(
                      hintText: 'Enter BirthDate',
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      value = userAge.toString();
                      //debugPrint('value: $value');
                      if(int.parse(value) < 18) return 'Under Age';

                    } ,
                    readOnly: true,
                    onTap: () async {
                     birthDate = await showDatePicker(
                          context: context,
                          initialDate: initDate,
                          firstDate: firstDate,
                          lastDate: lastDate);
                     if(birthDate == null) return;
                     userAge = CalculateUserData().calculateAge(birthDate!);
                     setState(() {
                       birthDateTextController.text = ('${birthDate!.year}/${birthDate!.month}/${birthDate!.day}');
                     });
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Flexible(
                      child: SizedBox(
                          width: 150,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            controller: nameTextController,
                          ))),
                  const SizedBox(
                    width: 50,
                  ),
                  Flexible(
                      child: SizedBox(
                          width: 150,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            controller: lastNameTextController,
                          )))
                ]),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'UserName',
                        border: OutlineInputBorder(),
                      ),
                      controller: userNameTextController,
                    )),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    height: 150,
                    width: 350,
                    child: TextFormField(
                      controller: aboutMeTextController,
                      expands: true,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'About Me',
                          border: OutlineInputBorder(),
                          labelText: 'About Me'),
                    )),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: activityTextController,
                      decoration: const InputDecoration(
                          hintText: 'add activity',
                          labelText: 'Add Activity',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                          isDense: true),
                      onFieldSubmitted: (value) {
                        setState(() {
                          activityList.add(activityTextController.text);
                        });
                        activityTextController.clear();
                      },
                    )),
                const SizedBox(
                  height: 5,
                ),
                Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    children: List.generate(activityList.length, (index) {
                      return Chip(
                        label: Text(activityList[index]),
                        onDeleted: () {
                          setState(() {
                            activityList.removeAt(index);
                          });
                        },
                      );
                    })),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text('WORKOUT TIMES',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      CheckboxListTile(
                          secondary: const Icon(Icons.wb_sunny_rounded),
                          title: const Text('Morning'),
                          value: isMorning,
                          onChanged: (bool? value) {
                            setState(() {
                              isMorning = value!;
                              if (value) {
                                workoutTimesList.add('Morning');
                                debugPrint(workoutTimesList.toString());
                              } else {
                                workoutTimesList.remove('Morning');
                                debugPrint(workoutTimesList.toString());
                              }
                            });
                            //value == true ? workoutTimes.add('value') : workoutTimes.remove('value');
                          }),
                      CheckboxListTile(
                          secondary: const Icon(Icons.wb_sunny_outlined),
                          title: const Text('Afternoon'),
                          value: isNoon,
                          onChanged: (bool? value) {
                            setState(() {
                              isNoon = value!;
                              if (value) {
                                workoutTimesList.add('Afternoon');
                                debugPrint(workoutTimesList.toString());
                              } else {
                                workoutTimesList.remove('Afternoon');
                                debugPrint(workoutTimesList.toString());
                              }
                            });
                            //value == true ? workoutTimes.add('value') : workoutTimes.remove('value');
                          }),
                      CheckboxListTile(
                          secondary: const Icon(Icons.shield_moon_rounded),
                          title: const Text('Evening'),
                          value: isEvening,
                          onChanged: (bool? value) {
                            setState(() {
                              isEvening = value!;
                            });
                            //value == true ? workoutTimes.add('value') : workoutTimes.remove('value');
                            if (value == true) {
                              workoutTimesList.add('Evening');
                              debugPrint(workoutTimesList.toString());
                            } else {
                              workoutTimesList.remove('Evening');
                              debugPrint(workoutTimesList.toString());
                            }
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50)),
                        onPressed: () async {
                          await _grabLocation();
                          signUp();
                        },
                        icon: const Icon(
                          Icons.lock_open,
                          size: 32,
                        ),
                        label: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 24),
                        ))),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Have an account? ',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                        children: [
                      TextSpan(
                        text: 'Sign In',
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                      )
                    ])),
                const SizedBox(
                  height: 20,
                )
              ],
            ))));
  }

  Future<void> _grabLocation() async {
    try {
      final LocationData results = await location.getLocation();
      setState(() {
        _location = results;
      });
    } on PlatformException catch (e) {
      print('not working$e');
    }
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    final name = nameTextController.text;
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message, context, Colors.red);
      //ScaffoldMessenger.of(context)
        //  .showSnackBar(const SnackBar(content: Text('Email Taken!')));
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

    // Storing data local
    await UserProfilePreferences.setUserInformationData(
        firstName: name,
        lastName: lastNameTextController.text,
        userName: userNameTextController.text,
        age: userAge.toString(),
        aboutMe: aboutMeTextController.text,
        activities: activityList,
        workoutTimes: workoutTimesList,
        userDistancePreference: 40);
    // Storing location local
    // Storing data in firebase
    createUserData(name: name);
  }

  //Apply user data
  Future createUserData({required String name}) async {
    final user = FirebaseAuth.instance.currentUser!;

    //FirebaseFirestore.instance.collection('users').doc(user.uid).set({"name": name });

    final docUser =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final userData = UserData(
      userIdDetails: user.uid.trim(),
      firstName: name,
      lastName: lastNameTextController.text.trim(),
      age: userAge,
      joinDate: DateTime.now(),
      activities: activityList,
      geoLocation: GeoPoint(
          _location!.latitude!.toDouble(), _location!.longitude!.toDouble()),
      aboutMe: aboutMeTextController.text.trim(),
      userName: userNameTextController.text.trim(),
      workoutTimes: workoutTimesList,
    );

    final json = userData.toFireStore();

    await docUser.set(json);
  }
}
