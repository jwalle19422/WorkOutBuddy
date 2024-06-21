//import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy/utils/utils.dart';
import 'chat_page.dart';

class WorkoutBuddyProfilePage extends StatelessWidget {
  const WorkoutBuddyProfilePage({required this.user});/* required this.friend});*/

  final UserData user;
  /*final FriendDetailData? friend;*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  const Text('Profile Page'),
          actions: [
            IconButton(
                onPressed: () {
                  /* call message function */
                   Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatPage(user: user)));
                },
                icon: const Icon(Icons.messenger_outlined)),
            IconButton(
                onPressed: () async {
                  /* call add friend function */
                  //debugPrint('user id: ${user.userIdDetails}');
                  //debugPrint('test: $isFriend');
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Would you like to add',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                            )),
                        content: Text(
                            '${user.userName!.toUpperCase()} as a friend',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                            )),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: ()  {
                                addFriend();
                                sendMyFriendDetails();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Add'))
                        ],
                      ));

                  //
                },
                icon: /* isFriend == true ?*/ const Icon(
                  Icons.people,
                ) /* : const Icon(Icons.check_circle,)*/),
            PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Report'),
                    onTap: () {},
                  ),
                  const PopupMenuItem(child: Text('Block'))
                ])
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  color: Colors.black,
                  height: 225,
                  child: Center(
                    child: Text(
                      user.firstName.toString().toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                Positioned(
                    top: 150,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      child: Center(
                          child: ClipOval(
                              child: Image.network(user.imgLink.toString(),
                                  width: 150, height: 150, fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                        return Text('Your error widget... $exception');
                      }))),
                    )),
                Positioned(
                    right: 125,
                    bottom: -90,
                    child: ClipOval(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Text(
                          user.age.toString(),
                          style: const TextStyle(fontSize: 18),
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
                          child: const Padding(
                              padding: EdgeInsets.all(18),
                              child: Text(
                                'Morning, Evening, Afternoon',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              )))),
                  const SizedBox(
                    height: 15,
                  ),
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
                                children: List.generate(user.activities!.length,
                                    (index) {
                                  return Chip(
                                      label: Text(user.activities![index],
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
                            child: Text(user.aboutMe.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18)),
                          ))),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ]),
        ));
  }

  //TODO This counts as a read so need to check cache before we check firebase
  Future<bool> friendCheck() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    bool isDocExist;
    final docCheck = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('friendList')
        .doc(user.userIdDetails);

    docCheck.get().then((doc) {
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    });
    debugPrint('is doc ');
    return true;
  }

  void addFriend() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final addFriendDetailsDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('friendList')
        .doc(user.userIdDetails);

    final friendDetails = FriendDetailData(
        friendIdDetails: user.userIdDetails?.trim(),
        firstName: user.firstName,
        lastName: user.lastName,
        friendUserName: user.userName,
        imgFriendLink: user.imgLink,
        eventDate: DateTime.now(),
        friendWorkoutTimes: user.workoutTimes,
        isRequested: true,
        isSentRequest: true,
        isFriend: false);

    final json = friendDetails.toFireStore();
    await addFriendDetailsDoc.set(json);

    // send logged in user details
  }

  void sendMyFriendDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String userId = user.userIdDetails.toString();
    final receiveFriendDetailDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId.trim())
        .collection('friendList')
        .doc(currentUser!.uid);

    final sendCurrentUserDetails = FriendDetailData(
        friendIdDetails: currentUser.uid.trim(),
        firstName: user.firstName,
        lastName: user.lastName,
        friendUserName: user.userName,
        imgFriendLink: user.imgLink,
        eventDate: DateTime.now(),
        friendWorkoutTimes: user.workoutTimes,
        isRequested: true,
        isSentRequest: false,
        isFriend: false);

    final sentJson = sendCurrentUserDetails.toFireStore();
    await receiveFriendDetailDoc.set(sentJson);
  }
}


