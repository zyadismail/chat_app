import 'package:chat_app_udemy/widgets/chat_messages.dart';
import 'package:chat_app_udemy/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  void signOut(){
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          )
        ]
        ),
      body: const  Column(
        children: [
          Expanded(
            child: ChatMessages()
            ),
          NewMessages(),
        ],
      )
    );
  }
}