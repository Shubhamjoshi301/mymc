import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmc/screens/showDiscrepancies.dart';

// ignore: must_be_immutable
class UserDetails extends StatelessWidget {
  UserDetails({Key? key}) : super(key: key);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var name = "";
  var userId = "";
  var aadharId = "";

 
  final FirebaseFirestore fbfs = FirebaseFirestore.instance;
 @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: fbfs.collection('userDetails').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 40,
                width: 40,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Verification"),
              backgroundColor: const Color(0xff262626),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Icon(
                    Icons.power_settings_new,
                    color: Color(0xffFBBC04),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                  onChanged: (newValue) {
                    name = newValue;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "AadarNo",
                  ),
                  onChanged: (newValue) {
                    aadharId = newValue;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    fbfs.collection('userDetails').add({
                      'name': name,
                      'aadharId': aadharId,
                      'userId':
                          FirebaseAuth.instance.currentUser!.uid.toString(),
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Discrepancies()));
                  },
                  child: const Text("submit"),
                ),
              ],
            ),
          );
        });
  }
}
