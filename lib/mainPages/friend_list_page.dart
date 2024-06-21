import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy/mainPages/workout_buddy_profile_page.dart';
import 'package:workout_buddy/utils/utils.dart';

import '../utils/cust_widgets.dart';


const int num = 0;
class FriendListPage extends StatefulWidget {
  const FriendListPage({Key? key}) : super(key: key);

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const NavigationDrawer(),
          appBar: AppBar(
            title: const Text('Friend List'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Friends',
                  icon: Icon(Icons.people),
                ),
                Tab(
                  text: 'Friend Request',
                  icon: num == 0 ? Icon(Icons.fiber_new) : Icon(Icons.fiber_new, color: Colors.green,) ,
                )
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              GetFriendList(
                requestPending: false,
              ),
              GetFriendList(
                requestPending: true,
              ),
            ],
          ),
        ));
  }
}

class GetFriendList extends StatefulWidget {
  const GetFriendList({required bool this.requestPending});

  final bool? requestPending;

  @override
  _GetFriendListState createState() => _GetFriendListState();
}

class _GetFriendListState extends State<GetFriendList> {
  late Future<List<QueryDocumentSnapshot<FriendDetailData>>> dataFuture;
  //late Future<List<QueryDocumentSnapshot<UserData>>> dataFuture;
  bool isAccepted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataFuture = getFriendList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot<FriendDetailData>>>(
      future: dataFuture,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Column(children: [
            const SizedBox(
              height: 25,
            ),
            Flexible(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return snapshot.data![index].data().isRequested ==
                              widget.requestPending
                          ? ListTile(
                              leading: ClipOval(
                                  child: snapshot.data![index].data().imgFriendLink !=
                                          null
                                      ? Image.network(
                                          snapshot.data![index]
                                              .data()
                                              .imgFriendLink
                                              .toString(),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        )
                                      : const Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/blankProfile.png'))),
                              title: Text( snapshot.data![index].data().isFriend == true ?
                                  '${snapshot.data![index].data().firstName} ${snapshot.data![index].data().lastName}' : '${snapshot.data![index].data().friendUserName}'),
                              subtitle: Text(snapshot.data![index]
                                  .data()
                                  .friendWorkoutTimes
                                  .toString()),
                              trailing:
                                  snapshot.data![index].data().isRequested ==
                                          true
                                      ? const Text('requested')
                                      : const Text('Friend'),
                              onTap: () async {
                                if (snapshot.data![index].data().isRequested ==
                                    false) {
                                  goToFriendPage(snapshot.data![index]
                                      .data()
                                      .friendIdDetails!
                                      .trim());
                                } else if(snapshot.data![index].data().isRequested ==
                                    true && snapshot.data![index].data().isSentRequest == false) {
                                  acceptFriendRequest(snapshot.data![index]
                                      .data()
                                      .friendIdDetails!
                                      .trim());
                                }
                              },
                            )
                          : const SizedBox.shrink();
                    }))
          ]);
        }
        if (snapshot.hasError) return Text('${snapshot.error}');

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<QueryDocumentSnapshot<FriendDetailData>>> getFriendList() async {
    final currentUser = FirebaseAuth.instance.currentUser!;

    final friendCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('friendList')
        .orderBy('firstName')
        .withConverter(
            fromFirestore: FriendDetailData.fromFireStore,
            toFirestore: (FriendDetailData userData, _) => userData.toFireStore());

    final getCollection = await friendCollection.get();

    final data = getCollection.docs;
    debugPrint('data: ${data.length}');
    return data;
  }

  Future<UserData?> getFriendDataPage(String friendId) async {
    //debugPrint('id: ${friendId}');
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(friendId.toString())
        .withConverter(
          fromFirestore: UserData.fromFireStore,
          toFirestore: (UserData userData, _) => userData.toFireStore(),
        );

    final docSnap = await ref.get();
    final data = docSnap.data();
    if (data == null) return null;/* {
      print(data.firstName);
    } else {
      print('no data');
    }*/
    return data;
  }

  void goToFriendPage(String friendId) async {
    UserData? data = await getFriendDataPage(friendId);
    debugPrint('about me: ${data!.aboutMe.toString()}');
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WorkoutBuddyProfilePage(
              user: data,
            )));
  }

  void acceptFriendRequest(String friendId) async {
    UserData? data = await getFriendDataPage(friendId);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Do you want To Add',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              content: Text(
                '${data!.userName!.toUpperCase()} as a friend ',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      declineRequest(data);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Decline')),
                TextButton(
                    onPressed: () {
                       updateStatus(data);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Accept')),
              ],
            ));
  }

  void updateStatus(UserData friendId) async{
    final currentUser = FirebaseAuth.instance.currentUser!;
    debugPrint(friendId.userIdDetails.toString());
    debugPrint(currentUser.uid);
    final currentUserDocRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid.toString()).collection('friendList').doc(friendId.userIdDetails.toString());
    final currentUserDataDoc = FriendDetailData(isRequested: false, isSentRequest: false, isFriend: true);
    final userJson = currentUserDataDoc.toFireStore();
    await currentUserDocRef.update(userJson);

    final friendDocRef = FirebaseFirestore.instance.collection('users').doc(friendId.userIdDetails.toString()).collection('friendList').doc(currentUser.uid.toString());
    final friendDataDoc = FriendDetailData(isRequested: false, isSentRequest: false, isFriend: true);
    final friendJson = friendDataDoc.toFireStore();
    await friendDocRef.update(friendJson);

    //final userUsersDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    //final userUsersData = UserData(friendsList: );

  }


  void declineRequest(UserData friendId) async{
    final currentUser = FirebaseAuth.instance.currentUser!;
     await FirebaseFirestore.instance.collection('users').doc(currentUser.uid.toString()).collection('friendList').doc(friendId.userIdDetails.toString()).delete();
     await FirebaseFirestore.instance.collection('users').doc(friendId.userIdDetails.toString()).collection('friendList').doc(currentUser.uid.toString()).delete();
  }
}
