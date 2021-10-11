// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmc/screens/choose_user.dart';
import 'package:mmc/widgets/discrepancies_card.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mmc/widgets/upload_Image.dart';

// ignore: must_be_immutable
class Discrepancies extends StatefulWidget {
  const Discrepancies({Key? key}) : super(key: key);

  @override
  State<Discrepancies> createState() => _DiscrepanciesState();
}

class _DiscrepanciesState extends State<Discrepancies> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('/notes.txt');
  var category = '';

  var description = '';

  Location location = Location();

  bool? _serviceEnabled;

  // PermissionStatus? _permissionGranted;

  LocationData? _locationData;

  FirebaseAuth fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore fbfs = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: StreamBuilder<QuerySnapshot>(
          stream: fireAuth.currentUser!.uid.toString() ==
                  "Png7OjmMtGOwQGGpDI67ddqmqyF3"
              ? fbfs.collection("discrepancies").snapshots()
              : fbfs
                  .collection("discrepancies")
                  .where('complainantUid',
                      isEqualTo:
                          FirebaseAuth.instance.currentUser!.uid.toString())
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChooseUser()));
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
                    color: Colors.black87,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      // itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        // print(snapshot.data!.docs.length);
                        return DiscrepanciesCard(
                          category: (snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>)['category'] as String,
                          date: (snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>)['date'] as Timestamp,
                          location: (snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>)['location'],
                        );
                        // return DiscrepanciesCard(category: "ddd", date:" 2/2/2 ");
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      // padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.all(30),
                      child: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            size: 60,
                            color: Color(0xffFBBC04),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: const Text("Add data"),
                                      content: SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            TextField(
                                              decoration: const InputDecoration(
                                                  hintText: "category"),
                                              onChanged: (newValue) {
                                                category = newValue;
                                              },
                                            ),
                                            TextField(
                                              decoration: const InputDecoration(
                                                  hintText: "Description"),
                                              onChanged: (newValue) {
                                                description = newValue;
                                              },
                                            ),
                                            Row(
                                              children: [
                                                const Expanded(
                                                    child: SizedBox()),
                                                const Text(
                                                    "Click to get location:"),
                                                IconButton(
                                                    onPressed: () async {
                                                      _serviceEnabled =
                                                          await location
                                                              .serviceEnabled();
                                                      if (!_serviceEnabled!) {
                                                        _serviceEnabled =
                                                            await location
                                                                .requestService();
                                                        if (_serviceEnabled!) {
                                                          return;
                                                        }
                                                      }
                                                      _locationData =
                                                          await location
                                                              .getLocation();
                                                      setState(() {});
                                                    },
                                                    iconSize: 30,
                                                    color: Colors.red,
                                                    icon: const Icon(Icons
                                                        .location_on_rounded)),
                                              ],
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  fbfs
                                                      .collection(
                                                          'discrepancies')
                                                      .add({
                                                    'category': category,
                                                    'description': description,
                                                    'complainantUid':
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                            .toString(),
                                                    'date': Timestamp.now(),
                                                    'isResolved': false,
                                                    'location': [
                                                      _locationData?.latitude,
                                                      _locationData?.longitude
                                                    ]
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("submit"))
                                          ],
                                        ),
                                      ),
                                    ));
                          }),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: UploadImage(),
                  )
                ],
              ),
            );
          }),
    );
  }
}
