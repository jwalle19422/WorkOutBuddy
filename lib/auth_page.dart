import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_buddy/signup_page.dart';

import 'login_page.dart';
import 'main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
      isLogin ? LoginPage(onClickedSignUp: toggle) : SignUpPage(onClickedSignIn: toggle);
      void toggle() => setState(() => isLogin = !isLogin);
}
