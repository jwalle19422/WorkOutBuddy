import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy/auth_page.dart';
import 'package:workout_buddy/mainPages/workout_buddyPage.dart';
import 'package:workout_buddy/settingFolder/setting_page.dart';
import 'package:workout_buddy/settingFolder/update_profile_page.dart';
import 'package:workout_buddy/utils/utils.dart';

import '../main.dart';
import '../utils/cust_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserData? currentUser;

  // For local storage
  String? firstName = '';
  String? lastName = '';
  String? userName = '';
  String? age = '';
  String? aboutMe = '';
  String? imgLink;
  List<String>? activityList = [];
  List<String>? workoutTimes = [];

  @override
  void initState() {
    // TODO: implement initState
    // getUserData();
    firstName = UserProfilePreferences.getFirstName() ??
        'go to setting and up date profile';
    lastName = UserProfilePreferences.getLastName() ?? '';
    userName = UserProfilePreferences.getUserName() ?? '';
    age = UserProfilePreferences.getAge() ?? '';
    aboutMe = UserProfilePreferences.getAboutMe() ?? '';
    activityList = UserProfilePreferences.getActivityList() ?? [];
    workoutTimes = UserProfilePreferences.getWorkoutTimes() ?? [];
    imgLink = UserProfilePreferences.getImgLink();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final nameTextController = TextEditingController();
    var user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('My Profile Page'),
          /*actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.messenger_outlined)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.people)),
            PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(child: Text('Report')),
                  const PopupMenuItem(child: Text('Block'))
                ])
          ],*/
        ),
        body: //FutureBuilder(
            //future: getUserData(),
            //builder: (BuildContext context, AsyncSnapshot<UserData?> snapshot) {
            //if (snapshot.hasData) {
            // setState(() {
            //currentUser = snapshot.data;
            // });
            /*return*/ SingleChildScrollView(
                child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  /*decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(18.0),
                              bottomRight: Radius.circular(18.0),
                            )
                          ),*/
                  color: Colors.black,
                  height: 225,
                  child: Center(
                    child: Text(
                      firstName
                          .toString()
                          .toUpperCase() /*snapshot.data!.lastName.toString().toUpperCase()*/,
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),

                // const  Divider(thickness: 5, color: Colors.white,),
                Positioned(
                    top: 145,
                    child: Container(
                      height: 160,
                      width: 160,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                          child: ClipOval(
                              child: imgLink != null
                                  ? Image.network(
                                      imgLink
                                          .toString() /*snapshot.data!.imgLink.toString(),*/,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover, errorBuilder:
                                          (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                      return Text('error... $exception');
                                    })
                                  : const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/blankProfile.png')))),
                    )),
                Positioned(
                    right: 125,
                    bottom: -90,
                    child: ClipOval(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: const Text(
                          '21',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 100,
            ),

            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
              ),
              /*shadowColor: Colors.black,
              elevation: 300,*/
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 35),
                          child: Text(
                            'Workout Times:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ))),
                  SizedBox(
                      width: 350,
                      height: 72,
                      child: Card(
                          shadowColor: Colors.black,
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(18),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: List.generate(
                                    workoutTimes!.length,
                                    (index) => Text(
                                        '${workoutTimes![index].toString()},  ',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20))),
                              )))),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 35),
                          child: Text(
                            'Activities:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ))),
                  SizedBox(
                      width: 350,
                      child: Card(
                          shadowColor: Colors.black,
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                direction: Axis.horizontal,
                                children: List.generate(
                                    activityList!
                                        .length /*snapshot.data!.activities!.length*/,
                                    (index) {
                                  return Chip(
                                      label: Text(activityList![index],
                                          style:
                                              const TextStyle(fontSize: 15)));
                                }),
                              )))),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 35),
                          child: Text(
                            'About:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ))),
                  SizedBox(
                      width: 350,
                      child: Card(
                          shadowColor: Colors.black,
                          elevation: 15,
                          //margin: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                                aboutMe
                                    .toString() /*snapshot.data!.aboutMe.toString()*/,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18)),
                          ))),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          ],
        )) /*;*/
        //}
        /*if (snapshot.hasError) {
                debugPrint('snapshot error ${snapshot.error.toString()}');
              }*/
        /*return const Center(
                child: CircularProgressIndicator(),*/
        //);
        /*})*/);
  }

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
    if (data != null) {
      print(data.firstName);
    } else {
      print('no data');
    }
    return data;
  }
}
