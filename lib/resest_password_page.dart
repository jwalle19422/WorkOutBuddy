import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_buddy/utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
    new GlobalKey<ScaffoldMessengerState>();

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  var utilsInstance = Utils();
  final emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 250, left: 25, right: 25),
            child: Form(
                key: formKey,
                child: Column(
                  children: [

                    TextFormField(
                      controller: emailTextController,
                      decoration:
                           InputDecoration(hintText: 'Enter Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                          )
                          ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter valid email'
                              : null,
                    ),
                    SizedBox(height: 15,),
                    ElevatedButton.icon(
                        onPressed: () => resetPassword(),
                        icon: const  Icon(Icons.email),
                        label: const Text('Reset Password'),

                    )
                  ],
                ))));
  }

  Future resetPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextController.text.trim());
      //Utils.showSnackBar('Email Sent');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Email sent')));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      Navigator.of(context).pop();
    }
  }
}
