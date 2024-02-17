import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {

  final messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }


  _sendMessage()async{
   final enterMessage =  messageController.text;
   if(enterMessage.trim().isEmpty){// trim to remove spaces
    return;
   }
  // ignore: use_build_context_synchronously
   FocusScope.of(context).unfocus();// to close the keyboard
   messageController.clear();// to remove the message after send 

   final User? user  = FirebaseAuth.instance.currentUser;
      final userData =   await FirebaseFirestore.instance.
        collection("users").doc(user!.uid).
        get();// to get the data of the user

        await FirebaseFirestore.instance.collection('chat').add({
      'text': enterMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14
      ),
      child: Row(
        children: [
           Expanded(
            child:  TextField(
            controller: messageController,
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            decoration: const  InputDecoration(
               labelText: "Send a Message",
            ),
          )),
          IconButton(
            onPressed: _sendMessage,
           icon:  Icon(
            Icons.send,
            color: Theme.of(context).colorScheme.primary,
            ),
           ),
        ],
      ),
    );
  }
}