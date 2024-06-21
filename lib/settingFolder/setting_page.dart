import 'package:flutter/material.dart';
import 'package:workout_buddy/settingFolder/location_setting_page.dart';
import 'package:workout_buddy/main.dart';
import 'package:workout_buddy/settingFolder/update_profile_page.dart';
import 'package:workout_buddy/utils/utils.dart';

import '../utils/cust_widgets.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          SizedBox(
              height: 100,
              child: ListTile(
                contentPadding: const EdgeInsets.all(25),
                tileColor: Colors.cyan,
                leading: const Icon(
                  Icons.account_circle,
                  size: 45,
                ),
                title: const Text(
                  'Update Profile',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  //DeleteUser().deleteUser();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UpdateProfilePage()));
                },
              )),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
              height: 100,
              child: ListTile(
                contentPadding: EdgeInsets.all(25),
                tileColor: Colors.cyan,
                leading: Icon(
                  Icons.email,
                  size: 45,
                ),
                title: Text(
                  'Change Email',
                  style: TextStyle(fontSize: 20),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
              height: 100,
              child: ListTile(
                contentPadding: EdgeInsets.all(25),
                tileColor: Colors.cyan,
                leading: Icon(
                  Icons.lock,
                  size: 45,
                ),
                title: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 20),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 100,
              child: ListTile(
                contentPadding: const EdgeInsets.all(25),
                tileColor: Colors.cyan,
                leading: const Icon(
                  Icons.location_on,
                  size: 45,
                ),
                title: const Text(
                  'Location',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LocationPage()));
                },
              )),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 100,
              child: ListTile(
                contentPadding: const EdgeInsets.all(25),
                tileColor: Colors.cyan,
                leading: const Icon(
                  Icons.delete,
                  size: 45,
                ),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text(
                                'Are you sure you would like to delete your account?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    DeleteUser().deleteUser();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage()));
                                  },
                                  child: const Text('Delete')),
                            ],
                          ));
                },
              )),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 100,
              child: ListTile(
                contentPadding: const EdgeInsets.all(25),
                tileColor: Colors.cyan,
                leading: const Icon(
                  Icons.newspaper,
                  size: 45,
                ),
                title: const Text(
                  'About',
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () => showAboutDialog(
                    context: context, applicationName: 'Workout Buddy'),
              ))
        ],
      ),
    );
  }
}
