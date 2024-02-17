import 'package:chat_app_udemy/screens/auth.dart';
import 'package:chat_app_udemy/screens/chatscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: const  FirebaseOptions(
    apiKey: "AIzaSyA3HlA7GmOqjdFI5XOdq-kbFGnNPZk24s0", 
    appId:  "1:369317233646:android:2f023735eadeba409744ff", 
    messagingSenderId: "369317233646", 
    projectId:  "chatapp-zyad",
    storageBucket: "chatapp-zyad.appspot.com",
    ),
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
          theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context ,snapshot ){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
            return const ChatScreen();
          }
            return const AuthScreen();
          
          // return  snapshot.connectionState == ConnectionState.waiting ? 
          // const AuthScreen():const ChatScreen();
        },
        ),
    );
  }
}