import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_storage/firebase_storage.dart';

import 'package:location/location.dart';

//TODO set up email for reported users to replace old report system before release

class Utils {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, BuildContext context, Color color) {
    final util = Utils();
    if (text == null) return;

    /*final snackBar =*/
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));

    // util.messengerKey.currentState!
    //   //..showSnackBar(snackBar)
    //   .removeCurrentSnackBar();
  }
}

class UserData {
  final String? userIdDetails;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final int? age;
  final DateTime? joinDate;
  final String? aboutMe;
  final List<String>? activities;
  final List<String>? workoutTimes;
  final List<String>? friendsList;
  final GeoPoint? geoLocation;
  final String? imgLink;
  late final bool? isRequested;
  final bool? isSentRequest;
  //TODO Things below
  // bool requested
  //friendList
  //reported flag
  //reason reported
  //metrics (probably won't do)

  UserData({
    this.userIdDetails,
     this.firstName,
    this.age,
    this.lastName,
    this.userName,
    this.joinDate,
    this.aboutMe,
    this.activities,
    this.workoutTimes,
    this.friendsList,
    this.geoLocation,
    this.imgLink,
    this.isRequested,
    this.isSentRequest
  });

  factory UserData.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserData(
        userIdDetails: data?['user id'],
        firstName: data?['name'],
        lastName: data?['lastName'],
        userName: data?['userName'],
        age: data?['age'],
        joinDate: data?['joinDate'].toDate(),
        aboutMe: data?['aboutMe'],
        activities: data?['activities'] is Iterable
            ? List.from(data?['activities'])
            : null,
        workoutTimes: data?['workout times'] is Iterable
            ? List.from(data?['workout times'])
            : null,
        friendsList: data?['friends list'] is Iterable
            ? List.from(['friends list'])
            :null,
        geoLocation: data?['geo location'],
        imgLink: data?['img location'],
        isRequested: data?['friend request'],
        isSentRequest: data?['sender']);
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (userIdDetails != null) 'user id': userIdDetails,
      if (firstName != null) 'name': firstName,
      if (lastName != null) 'lastName': lastName,
      if (userName != null) 'userName': userName,
      if (age != null) 'age': age,
      if (joinDate != null) 'joinDate': joinDate,
      if (aboutMe != null) 'aboutMe': aboutMe,
      if (activities != null) 'activities': activities,
      if (workoutTimes != null) 'workout times': workoutTimes,
      if (friendsList != null) 'friends list': friendsList,
      if (geoLocation != null) 'geo location': geoLocation,
      if (imgLink != null) 'img location': imgLink,
      if (isRequested != null) 'friend request': isRequested,
      if (isSentRequest != null) 'sender': isSentRequest,
    };
  }
}

class FriendDetailData {
  final String? friendIdDetails;
  final String? firstName;
  final String? lastName;
  final String? friendUserName;
  final List<String>? friendWorkoutTimes;
  final String? imgFriendLink;
  final bool? isRequested;
  final bool? isSentRequest;
  final bool? isFriend;
  final DateTime? eventDate;

  FriendDetailData(
      {this.friendIdDetails,
       this.firstName,
       this.lastName,
       this.friendUserName,
       this.friendWorkoutTimes,
       this.imgFriendLink,
       this.isRequested,
       this.isSentRequest,
       this.isFriend,
       this.eventDate});

  factory FriendDetailData.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FriendDetailData(
      friendIdDetails: data?['friendUserId'],
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      friendUserName: data?['friendUserName'],
      friendWorkoutTimes: data?['workout times'] is Iterable
          ? List.from(data?['workout times'])
          : null,
      imgFriendLink: data?['img link'],
      isRequested: data?['friend request'],
      isSentRequest: data?['sender'],
      isFriend: data?['is friend'],
      eventDate: data?['eventDate'].toDate(),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (friendIdDetails != null) 'friendUserId': friendIdDetails,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (friendUserName != null) 'friendUserName': friendUserName,
      if (eventDate != null) 'eventDate': eventDate,
      if (friendWorkoutTimes != null) 'workout times': friendWorkoutTimes,
      if (imgFriendLink != null) 'img link': imgFriendLink,
      if (isRequested != null) 'friend request': isRequested,
      if (isFriend != null) 'is friend': isFriend,
      if (isSentRequest != null) 'sender': isSentRequest,
    };
  }
}

class DeleteUser {
  Future deleteUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    //TODO have to loop through docs
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('friendList').doc().delete();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    // get user profile picture
    FirebaseStorage.instance.ref('profilePictures/${user.uid}').delete();
    user.delete();
    await FirebaseAuth.instance.signOut();
  }
}

class SignOut {
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

class CalculateUserData {
  bool calculateDistance(
      double lat1, double lat2, double lon1, double lon2, double mileDistance) {
    //check if calculated distance is less then user preference
    // return true else return false

    double km = 0.62137;

    lat1 = vector.radians(lat1);
    lat2 = vector.radians(lat2);
    lon1 = vector.radians(lon1);
    lon2 = vector.radians(lon2);

    var dlon = lon2 - lon1;
    var dlat = lat2 - lat1;

    double a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);

    double c = 2 * asin(sqrt(a));

    double kmResult = (c * 6371);
    double miResult = kmResult * km;
    //debugPrint('distance in km: $kmResult ==> to distance in mi $miResult');

    if (miResult <= mileDistance) return true;

    return false;
  }

  int calculateAge(DateTime birthDate) {
    //TODO calculate age down to the Day!!
    DateTime currentDate = DateTime.now();

    int? age;

    age = (currentDate.year - birthDate.year);
    debugPrint('age: $age');
    return age;
  }
}

class UserProfilePreferences {
  static SharedPreferences? _preferences;
  late final String? imgLink;

  // User info data
  static const _keyUserFirstName = 'fistNameData';
  static const _keyUserLastName = 'lastNameData';
  static const _keyUserName = 'userNameData';
  static const _keyUserAge = 'ageData';
  static const _keyAbout = 'aboutMeData';
  static const _keyActivityList = 'activityData';
  static const _keyWorkoutTimesList = 'workoutTimesData';
  static const _keyUserImageLink = 'imageLinkData';

  // Location data
  static const _keyLocationLat = 'locationDataLat';
  static const _keyLocationLog = 'locationDataLog';
  static const _keyDistancePreference = 'distanceData';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserProfileImage({required String imgLink}) async {
    await _preferences?.setString(_keyUserImageLink, imgLink);
  }

  static Future setUserInformationData(
      {required String firstName,
      required String lastName,
      required String userName,
      String? age,
      required String aboutMe,
      required List<String> activities,
      required List<String> workoutTimes,
      required int userDistancePreference}) async {
    await _preferences?.setString(_keyUserFirstName, firstName);
    await _preferences?.setString(_keyUserLastName, lastName);
    await _preferences?.setString(_keyUserName, userName);
    await _preferences?.setString(_keyUserAge, age!);
    await _preferences?.setString(_keyAbout, aboutMe);
    await _preferences?.setStringList(_keyActivityList, activities);
    await _preferences?.setStringList(_keyWorkoutTimesList, workoutTimes);
  }

  static String? getFirstName() => _preferences?.getString(_keyUserFirstName);

  static String? getLastName() => _preferences?.getString(_keyUserLastName);

  static String? getUserName() => _preferences?.getString(_keyUserName);

  static String? getAge() => _preferences?.getString(_keyUserAge);

  static String? getAboutMe() => _preferences?.getString(_keyAbout);

  static List<String>? getActivityList() =>
      _preferences?.getStringList(_keyActivityList);

  static List<String>? getWorkoutTimes() =>
      _preferences?.getStringList(_keyWorkoutTimesList);

  static String? getImgLink() => _preferences?.getString(_keyUserImageLink);

  //Location
  static Future setLocationData(double lat, double log) async {
    await _preferences?.setDouble(_keyLocationLat, lat);
    await _preferences?.setDouble(_keyLocationLog, log);
  }

  static double? getLocationDataLat() =>
      _preferences?.getDouble(_keyLocationLat);

  static double? getLocationDataLog() =>
      _preferences?.getDouble(_keyLocationLog);

  static Future setDistancePreference(double disPref) async {
    await _preferences?.setDouble(_keyDistancePreference, disPref);
  }

  static double? getDistancePreference() =>
      _preferences?.getDouble(_keyDistancePreference);

  // Save Image and Get Image
  static Future<File> saveImage(String imgPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imgPath);
    final image = File('${directory.path}/$name');

    return File(imgPath).copy(image.path);
  }
}

class FirebaseUtils{
  final user = FirebaseAuth.instance.currentUser!;

  //  Future<FriendDetailData> getLoggedUserDetaill() async{
  //
  //    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  //
  //
  //
  // }
}


class UserCurrentLocation {
  final Location location = Location();

  Future<LocationData> getLocation() async {
    //try {
    final LocationData results = await location.getLocation();
    return results;
    //}on PlatformException catch (e) {
    // print('not working$e');
    //}
  }
}
