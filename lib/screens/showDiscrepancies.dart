// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmc/screens/choose_user.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mmc/widgets/category_dropdown.dart';
import 'package:mmc/widgets/dialog.dart';
import 'package:mmc/widgets/discrepancies_card.dart';

import 'package:firebase_storage/firebase_storage.dart';


// ignore: must_be_immutable
class Discrepancies extends StatefulWidget {
  const Discrepancies({Key? key}) : super(key: key);

  @override
  State<Discrepancies> createState() => _DiscrepanciesState();
}

class _DiscrepanciesState extends State<Discrepancies> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = FirebaseStorage.instance.ref('/notes.txt');
  var category = '';

  CategoryDropdown categorydrop = CategoryDropdown();
  String showcategory = "All";

  FirebaseAuth fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore fbfs = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: StreamBuilder<QuerySnapshot>(
        stream: showcategory == "All"
            ? fireAuth.currentUser!.uid.toString() ==
                    "Png7OjmMtGOwQGGpDI67ddqmqyF3"
                ? fbfs.collection("discrepancies").orderBy("date").snapshots()
                : fbfs
                    .collection("discrepancies")
                    .where(
                      'complainantUid',
                      isEqualTo:
                          FirebaseAuth.instance.currentUser!.uid.toString(),
                    )
                    .orderBy("date")
                    .snapshots()
            : fireAuth.currentUser!.uid.toString() ==
                    "Png7OjmMtGOwQGGpDI67ddqmqyF3"
                ? fbfs
                    .collection("discrepancies")
                    .where('category', isEqualTo: showcategory)
                    .orderBy("date")
                    .snapshots()
                : fbfs
                    .collection("discrepancies")
                    .where(
                      'complainantUid',
                      isEqualTo:
                          FirebaseAuth.instance.currentUser!.uid.toString(),
                    )
                    .where('category', isEqualTo: showcategory)
                    .orderBy("date")
                    .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                // height: 40,
                width: 40,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("My Discrepancies"),
              backgroundColor: const Color(0xff262626),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseUser(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.power_settings_new,
                    color: Color(0xffFBBC04),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 60),
                  color: Colors.black87,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var temp = (snapshot.data!.docs[index].data()!
                          as Map<String, dynamic>);
                      return DiscrepanciesCard(
                          category: temp['category'] as String,
                          date: temp['date'] as Timestamp,
                          location: temp['location'],
                          imageId: temp['imageId'] as String,
                          docId: snapshot.data!.docs[index].id);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        size: 40,
                        color: Color(0xffFBBC04),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => const NewDiscrepancyPopup()
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 120,
                    height: 40,
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItems: true,
                        items: const [
                          "Civic Cleanliness",
                          "Electrical Equipments",
                          "Transport",
                          'Roads',
                          "All"
                        ],
                        onChanged: (value) {
                          setState(() {
                            showcategory = value!;
                          });
                        },
                        selectedItem: "All"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
