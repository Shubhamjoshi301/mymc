// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmc/widgets/discrepancies_card.dart';

// ignore: must_be_immutable
class Discrepancies extends StatelessWidget {
  Discrepancies({Key? key}) : super(key: key);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var name = "";
  var userId = "";
  var aadharId = "";

  final FirebaseFirestore fbfs = FirebaseFirestore.instance;
  // Future getDocs() async {
  //   Query<Map<String, dynamic>> querySnapshot = fbfs
  //       .collection("discrepancies")
  //       .where('userId',
  //           isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString());
  //   for (int i = 0; i < querySnapshot.length; i++) {
  //     var a = querySnapshot.documents[i];
  //     print(a.documentID);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: fbfs
            .collection("discrepancies")
            .where('complainantUid',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
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
          // List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          return Scaffold(
            appBar: AppBar(
              title: const Text("My Discrepancies"),
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
            body: Container(child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return DiscrepanciesCard(
                  category: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)['category'] as String,
                  date: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)['date'] as DateTime,
                );
              },
            )),
          );
        });
  }
}
