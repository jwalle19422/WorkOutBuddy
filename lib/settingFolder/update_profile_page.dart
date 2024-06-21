import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_buddy/utils/utils.dart';

import '../utils/cust_widgets.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late Future<UserData?> futureData;

  final userNameTextController = TextEditingController();

  final firstNameTextController = TextEditingController();

  final lastNameTextController = TextEditingController();

  final aboutMeTextController = TextEditingController();

  final activitieTextController = TextEditingController();

  List<String>? activityList = [];
  List<String>? workoutTimesList = [];

  bool isMorning = false;
  bool isNoon = false;
  bool isEvening = false;

  File? image ;
  String? profileImage;
  var defaultImage  = const AssetImage('assets/blankProfile.png') ;

  Future pickImage(ImageSource? source) async {
    try {
      final image = await ImagePicker().pickImage(source: source!);
      if (image == null) return;

      final imageTemp = File(image.path);
      final savedImage = await UserProfilePreferences.saveImage(image.path);
      setState(() {
        //this.image = savedImage;
        this.image = imageTemp;});
    } on PlatformException catch (e) {
      print('faild to get image');
    }
    await getProfilePicture();
    await UserProfilePreferences.setUserProfileImage(imgLink: profileImage!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureData = getUserData();
    profileImage = UserProfilePreferences.getImgLink();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
            child: Column(
          children: [
            ProfileWidget(
                imgLink: profileImage,
                onClicked: () async {
                  showBottomSheet();
                }),
            const SizedBox(
              height: 20,
            ),
           //Text(profileImage!),
            FutureBuilder(
                future: futureData,
                builder:
                    (BuildContext context, AsyncSnapshot<UserData?> snapshot) {
                  if (snapshot.hasData) {
                    if(userNameTextController.text.isEmpty) userNameTextController.text = snapshot.data!.userName ?? '';
                    if(firstNameTextController.text.isEmpty) firstNameTextController.text = snapshot.data!.firstName ?? '';
                    if(lastNameTextController.text.isEmpty) lastNameTextController.text = snapshot.data!.lastName ?? '';
                    if(aboutMeTextController.text.isEmpty) aboutMeTextController.text = snapshot.data!.aboutMe ?? '';
                    if (activityList!.isEmpty) activityList = snapshot.data!.activities ?? [];
                    if (workoutTimesList!.isEmpty) workoutTimesList = snapshot.data!.workoutTimes ?? [];
                    if(snapshot.data!.workoutTimes!.contains('Morning')) isMorning = true;
                    if(snapshot.data!.workoutTimes!.contains('Afternoon')) isNoon = true;
                    if(snapshot.data!.workoutTimes!.contains('Evening'))  isEvening = true;
                    return Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'UserName',
                            labelText: 'UserName',
                            border: OutlineInputBorder(),
                          ),
                          controller: userNameTextController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'First Name',
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
                              ),
                              controller: firstNameTextController,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Flexible(
                              child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            controller: lastNameTextController,
                          )),
                        ]),
                        const SizedBox(
                          height: 20,
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
                          height: 20,
                        ),
                        TextFormField(
                          controller: activitieTextController,
                          decoration: const InputDecoration(
                              hintText: 'add activity',
                              labelText: 'Add Activity',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(10),
                              isDense: true),
                          onFieldSubmitted: (value) {
                            setState(() {
                              activityList!.add(activitieTextController.text);
                            });
                            activitieTextController.clear();
                          },
                        ),
                        Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            children:
                                List.generate(activityList!.length, (index) {
                              return Chip(
                                label: Text(activityList![index]),
                                onDeleted: () {
                                  setState(() {
                                    activityList!.removeAt(index);
                                  });
                                },
                              );
                            })),
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
                                        workoutTimesList!.add('Morning');
                                        debugPrint(workoutTimesList.toString());
                                      } else {
                                        workoutTimesList!.remove('Morning');
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
                                        workoutTimesList!.add('Afternoon');
                                        debugPrint(workoutTimesList.toString());
                                      } else {
                                        workoutTimesList!.remove('Afternoon');
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
                                      workoutTimesList!.add('Evening');
                                      debugPrint(workoutTimesList.toString());
                                    } else {
                                      workoutTimesList!.remove('Evening');
                                      debugPrint(workoutTimesList.toString());
                                    }
                                  })
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('error');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () async {
                      updateUser(
                        name: firstNameTextController.text,
                        about: aboutMeTextController.text,
                        username: userNameTextController.text,
                      );
                    },
                    icon: const Icon(
                      Icons.update,
                      size: 32,
                    ),
                    label: const Text(
                      'Update',
                      style: TextStyle(fontSize: 24),
                    ))),
            const SizedBox(height: 15,)
          ],
        )),
      ),
    );
  }

  showBottomSheet() => showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Camera'),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Gallery'),
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              )
            ],
          )));

  Future<UserData?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .withConverter(
          fromFirestore: UserData.fromFireStore,
          toFirestore: (UserData userData, _) => userData.toFireStore(),
        );

    final docSnap = await ref.get();
    final data = docSnap.data();
    if (data == null) return null;

    return data;
  }

 Future getProfilePicture() async{
    final user = FirebaseAuth.instance.currentUser!;
     final fs = FirebaseStorage.instance;
      final rootref = fs.ref();
      final picRef = rootref.child('profilePicture').child(user.uid.toString());
      if(image == null) return;
      await picRef.putFile(image!).then((snapshot) async {
       String link = await snapshot.ref.getDownloadURL();
       setState(() {
         profileImage = link.toString();
         print('url: ${link.toString()}');
       });
     });


  }

  void updateUser(
      {required String name,
      required String about,
      required String username}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final updateData =
        FirebaseFirestore.instance.collection('users').doc(user.uid);


    final userData = UserData(
        firstName: name,
        /*age: 21,*/
        userName: username,
        activities: activityList,
        aboutMe: about,
        lastName: lastNameTextController.text.trim(),
        workoutTimes: workoutTimesList,
        imgLink:profileImage!);

    final json = userData.toFireStore();

    await updateData.update(json);

    await UserProfilePreferences.setUserInformationData(
        firstName: name,
        lastName: lastNameTextController.text,
        userName: userNameTextController.text,
        age: 21.toString(),
        aboutMe: aboutMeTextController.text,
        activities: activityList!,
        workoutTimes: workoutTimesList!,
        userDistancePreference: 50,);

    if(!mounted) return;
    Utils.showSnackBar('Update Success', context, Colors.green);
   }
}
