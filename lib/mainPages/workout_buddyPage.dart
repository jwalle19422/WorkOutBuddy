import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:workout_buddy/mainPages/workout_buddy_profile_page.dart';

import 'package:firebase_storage/firebase_storage.dart';
import '../utils/cust_widgets.dart';
import 'home_page.dart';
import '../utils/utils.dart';

class WorkOutBuddyPage extends StatefulWidget {
  const WorkOutBuddyPage({Key? key}) : super(key: key);

  @override
  _WorkOutBuddyPageState createState() => _WorkOutBuddyPageState();
}

class _WorkOutBuddyPageState extends State<WorkOutBuddyPage> {
  late Future<List<QueryDocumentSnapshot<UserData>>> dataFuture;
  final loggedUser =FirebaseAuth.instance.currentUser!;

  double latitude = 0.0;
  double longitude = 0.0;
  double distance = 0.0;
  LocationData? _location;

  Future<void> getLocation() async {
    _location = await UserCurrentLocation().getLocation();
  }

  //TODO Add refresh widget for updating location

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    latitude = UserProfilePreferences.getLocationDataLat() ?? 0;
    longitude = UserProfilePreferences.getLocationDataLog() ?? 0;
    distance = UserProfilePreferences.getDistancePreference() ?? 0;
    //debugPrint('location: ${latitude.toString()}');
    dataFuture = getUsersData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Workout Buddy'),
        ),
        body: Column(
          children: [
            FutureBuilder<List<QueryDocumentSnapshot<UserData>>>(
                future: dataFuture,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              if (CalculateUserData().calculateDistance(
                                // _location?.latitude ??
                                  latitude /*42.27386148108703*/,
                                  snapshot.data![index]
                                      .data()
                                      .geoLocation
                                      ?.latitude ??
                                      0.0,
                                  // _location?.longitude ??
                                  longitude /*-85.5702774081044*/,
                                  snapshot.data![index]
                                      .data()
                                      .geoLocation
                                      ?.longitude ??
                                      0.0,
                                  distance)) {
                                debugPrint(
                                    'location: LAT: ${latitude
                                        .toString()}\nLON ${longitude
                                        .toString()}\nDIS ${distance
                                        .toString()}');

                                return ListTile(
                                  leading: ClipOval(
                                      child: snapshot.data![index]
                                          .data()
                                          .imgLink !=
                                          null
                                          ? Image.network(
                                        snapshot.data![index]
                                            .data()
                                            .imgLink
                                            .toString(),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                          : const Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/blankProfile.png'))),
                                  title: Text(snapshot.data![index]
                                      .data()
                                      .userName
                                      .toString()),
                                  subtitle: const Text(
                                      'Workout Times: Morning, Evenings'),
                                  onTap: () {
                                    //FriendDetailData friend = await currentUserFriend(snapshot.data![index].data().userIdDetails!);
                                    //if(!mounted) return;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WorkoutBuddyProfilePage(
                                                    user: snapshot.data![index]
                                                        .data())));
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                              ;
                            }));
                  }

                  return const Center(child: CircularProgressIndicator());
                })
          ],
        ));
  }

  Future<List<QueryDocumentSnapshot<UserData>>> getUsersData() async {
    //final user = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .withConverter(
        fromFirestore: UserData.fromFireStore,
        toFirestore: (UserData userData, _) => userData.toFireStore());

    final dataSnap = await ref.get();
    final data = dataSnap.docs;
    //print(data);
    return data;
  }

  Future<FriendDetailData> currentUserFriend(
      String listedUser) async{
    final user = FirebaseAuth.instance.currentUser!;

    final friendDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(listedUser)
        .collection('friendList').doc(user.uid).withConverter(
        fromFirestore: FriendDetailData.fromFireStore, toFirestore: (FriendDetailData friendData, _)=> friendData.toFireStore());
    final friendSnap = await friendDoc.get();
    final friendData = friendSnap.data();

    return friendData!;


  }
}
