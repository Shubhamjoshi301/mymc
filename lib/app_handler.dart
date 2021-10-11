import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mmc/screens/choose_user.dart';
import 'package:mmc/screens/error_screen.dart';
import 'package:mmc/screens/login.dart';
import 'package:mmc/screens/user_details.dart';
import 'package:mmc/screens/showDiscrepancies.dart';

class AppHandler extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  AppHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MMC',
      home: SafeArea(
        child: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return const ErrorScreen();
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return AuthHandler();
            }

            // Otherwise, show something whilst waiting for initialization to complete

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fbfs = FirebaseFirestore.instance;
  AuthHandler({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        // If user is logged in
        if (snapshot.hasData && !snapshot.data!.isAnonymous) {
          

          return StreamBuilder<QuerySnapshot>(
              stream: fbfs
                  .collection("userDetails")
                  .where('userId',
                      isEqualTo:
                          FirebaseAuth.instance.currentUser!.uid.toString())
                  .snapshots(),
              builder: (context, snapshot2) {
               
                if (snapshot2.hasData && snapshot2.data!.docs.isEmpty) {
                  
                  return UserDetails();
                }
                else{
                  return const  Discrepancies();
                }
                
              });
        }

        // If user is not Logged in
        else {
          return const ChooseUser();
        }
      },
    );
  }
}
