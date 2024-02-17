// import 'package:chat_app_udemy/widgets/user_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// final auth =  FirebaseAuth.instance;
// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final  GlobalKey<FormState> formkey = GlobalKey<FormState>();
//   var enteredEmail = '';
//   var enteredUsername = '';
//   var enteredPassword = '';
//   var islogin  = true;


//   void submit() async {
//     final valid = formkey.currentState!.validate();

//     if (!valid) {
//       return;
//     }

//     try {
//       if (islogin) {
//         await auth.signInWithEmailAndPassword(
//           email: enteredEmail,
//           password: enteredPassword,
//         );
//       } else {
//         final UserCredential userCredential =
//             await auth.createUserWithEmailAndPassword(
//           email: enteredEmail,
//           password: enteredPassword,
//         );

//       }
//     } on FirebaseAuthException catch (e) {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).clearSnackBars();
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.message ?? 'Authentication failed.'),
//         ),
//       );
//     }

//     formkey.currentState!.save();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 margin:const EdgeInsets.only(
//                   top: 30,
//                   bottom: 30,
//                   left: 20,
//                   right: 20,
//                 ),
//                width: 200,
//                child: Image.asset("assets/images/chat.png"), 
//               ),
//                Card(
//                 margin: const EdgeInsets.all(20),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Form(
//                       key: formkey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         verticalDirection: VerticalDirection.down,
//                         textDirection: TextDirection.ltr,
//                       children: [
//                         if(!islogin)
//                         const SizedBox(
//                           height: 10,
//                           child:  UserImagePicker()
//                           ),
//                         TextFormField(
//                           decoration: const InputDecoration(
//                            labelText: "Email Address",
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           autocorrect: false,
//                           textCapitalization: TextCapitalization.none,
//                           onSaved: (value)=> enteredEmail = value!,
//                           validator: (value){
//                             if(value == null || value.trim().isEmpty || !value.contains("@")){
//                               return "please enter a valid email";
//                             }
//                             return null;
//                           },
//                         ),
//                           TextFormField(
//                           decoration: const InputDecoration(
//                            labelText: "Password",
//                           ),
//                           obscureText: true,
//                           onSaved: (value)=> enteredPassword = value!,
//                              validator: (value){
//                             if(value == null || value.trim().length < 6){
//                               return "please enter a valid password";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height:12 ,),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//                           ),
//                           onPressed: submit,
//                          child: Text(islogin? "Login" : "Signup"),
//                          ),
//                        const SizedBox(height:12 ,),
//                            TextButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     islogin = !islogin;
//                                   });
//                                 },
//                                 child: Text(
//                                   islogin
//                                       ? 'Create an account'
//                                       : 'I already have an account',
//                                 ),
//                               ),
//                       ],
//                     )),
//                   ),
//                 ),
//                            )
//             ]),
//         ),
//       ),
//     );
//   }
// }





// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/user_image.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';
  File? _selectedImage;
  var _isUploading = false;

  void _submit() async {
    final valid = _formKey.currentState!.validate();

    if (!valid || (!_isLogin && _selectedImage == null)) {
      return;
    }

    try {
      setState(() {
        _isUploading = true;
      });
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final UserCredential userCredential =
            await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        log(imageUrl);

        await FirebaseFirestore.instance.
        collection("users").
        doc(userCredential.user!.uid).
        set({
          "username" : _enteredUsername,
          "email" : _enteredEmail,
          "password" : _enteredPassword,
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isUploading = false;
      });
    }

    _formKey.currentState!.save();
    log(_enteredEmail);
    log(_enteredPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                  right: 20,
                  left: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (File pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Adrress',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (value) => _enteredEmail = value!,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              onSaved: (value) => _enteredUsername = value!,
                              validator: (value) {
                                if (value == null || value.trim().length < 4) {
                                  return 'Please enter at least 4 characters.';
                                }
                                return null;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            onSaved: (value) => _enteredPassword = value!,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isUploading) const CircularProgressIndicator(),
                          if (!_isUploading)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                          if (!_isUploading)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Create an account'
                                    : 'I already have an account',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
