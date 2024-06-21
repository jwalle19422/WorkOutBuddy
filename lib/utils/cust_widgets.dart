import 'package:flutter/material.dart';
import 'package:workout_buddy/utils/utils.dart';

import '../main.dart';
import '../mainPages/friend_list_page.dart';
import '../mainPages/home_page.dart';
import '../mainPages/workout_buddyPage.dart';
import '../settingFolder/setting_page.dart';









class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Welcome Workout Buddy')),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Home'),
              onTap: () {
                //DeleteUser().deleteUser();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }),
          ListTile(
            leading: const Icon(Icons.people_alt),
            title: const Text('Find Workout Buddy'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const WorkOutBuddyPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_outlined),
            title: const Text('Friends'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const FriendListPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Messages'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Setting'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              SignOut().signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          )
        ],
      ),
    );
  }
}


class ProfileWidget extends StatelessWidget {
  //final File? imagePath;
  final String? imgLink;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imgLink,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(children: [
          buildImage(),
          Positioned(bottom: 0, right: 4, child: buildEditButton(Colors.blue)),
        ]));
  }

  Widget buildImage() {
    final image = imgLink;
    return GestureDetector(
        onTap: onClicked,
        child: ClipOval(
          child: image != null
              ? Image.network(
            image,
            width: 128,
            height: 128,
            fit: BoxFit.cover,
          )
              : const Image(
            image: AssetImage('assets/blankProfile.png'),
            width: 128,
            height: 128,
          ),
        ));
  }

  Widget buildEditButton(Color color) => buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
          color: Colors.lightBlue,
          all: 8,
          child: const Icon(
            Icons.edit,
            size: 20,
          )));

  Widget buildCircle(
      {required Widget child, required double all, required Color color}) =>
      ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            color: color,
            child: child,
          ));
}

