import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy/mainPages/home_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendEmailVerify();
      Timer.periodic(
        Duration(seconds: 3),
          (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified ? HomePage() : Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Center(child: Column(children: [
       const Text('Email has been sent'),
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.email), label: const Text('Resend email')),
        ElevatedButton(onPressed: () => cancelEmail(), child: const Text('Cancel'))
      ],),),
    );
  }

 Future sendEmailVerify() async {
   try {
     final user = FirebaseAuth.instance.currentUser!;
     await user.sendEmailVerification();
   } on FirebaseAuthException catch(e){
     print(e);
   }
 }

 Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) timer?.cancel();
 }

  Future cancelEmail() async {
    await FirebaseAuth.instance.signOut();
  }
}
