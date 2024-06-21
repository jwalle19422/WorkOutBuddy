import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({required this.user});
  //const ChatPage({Key? key}) : super(key: key);
  final UserData user;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  Text('Chat with ${user.firstName!.toUpperCase()}'),
      ),
        body:  Center(child: Text('Chat with ${user.firstName!.toUpperCase()}', style: const TextStyle(fontSize: 30),)));
  }
}
