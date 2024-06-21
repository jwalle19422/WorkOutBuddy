import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_buddy/resest_password_page.dart';
import 'package:workout_buddy/utils/utils.dart';

import 'main.dart';
//import 'package:firebase_auth_email/mail.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  var utilsInstance = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 150, left: 45, right: 45),
              child: Column(
                children: [
                  const Text(
                    "WORKOUT BUDDY",
                    textAlign: TextAlign.center,
                    style: TextStyle(

                        fontWeight: FontWeight.w900,
                        fontSize: 45,
                        fontFamily: 'GoogleFonts.jockeyOne()',
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: emailTextController,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                      obscureText: true,
                      //obscuringCharacter: 'p' replace with dumbbell emoji later,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      controller: passwordTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: 250,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: const Size.fromHeight(45)),
                          onPressed: () => signIn(),
                          icon: const Icon(
                            Icons.lock_open,
                            size: 32,
                          ),
                          label: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 20),
                          ))),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: 250,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: const Size.fromHeight(45)),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.lock_open,
                            size: 32,
                          ),
                          label: const Text(
                            'Sign In With Google',
                            style: TextStyle(fontSize: 20),
                          ))),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 16),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPassword())),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'No Account? ',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          children: [
                        TextSpan(
                          text: 'Sign Up',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                        )
                      ]))
                ],
              ))),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message, context, Colors.black);
      //ScaffoldMessenger.of(context)
      //  .showSnackBar( SnackBar(content: Text('${e.message.toString()}')));
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
