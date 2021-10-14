// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmc/screens/choose_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmc/widgets/category_dropdown.dart';
import 'package:mmc/widgets/discrepancies_card.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  var description = '';

  Location location = Location();
  var imageFile;
  bool? _serviceEnabled;

  // PermissionStatus? _permissionGranted;

  LocationData? _locationData;

  FirebaseAuth fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore fbfs = FirebaseFirestore.instance;
  final picker = ImagePicker();

  Future<int> getImagesLength() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();

    // result.items.forEach((Reference ref) {
    //   print('Found file: $ref');
    // });

    // result.prefixes.forEach((Reference ref) {
    //   print('Found directory: $ref');
    // });
    return result.items.length;
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    imageFile = File(pickedFile!.path);
  }

  Future<String> getImageId() async {
    String id = 'image' +
        fireAuth.currentUser!.uid.toString() +
        "_" +
        DateTime.now().toString() +
        '.png';
    return id;
  }

  Future<String> uploadImageToFirebase() async {
    String imageId = await getImageId();
    try {
      await storage.ref(imageId).putFile(imageFile);
    } on FirebaseException catch (e) {
      print(e);
    }
    return imageId;
  }

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
                          builder: (ctx) => AlertDialog(
                            title: const Text("Submit Discrepancies"),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  categorydrop,
                                  TextField(
                                    decoration: const InputDecoration(
                                        hintText: "Description"),
                                    onChanged: (newValue) {
                                      description = newValue;
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                                  ElevatedButton.icon(
                                    label: const Text("Upload Image"),
                                    icon: const Icon(
                                      Icons.upload_file_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: pickImage,
                                  ),
                                  ElevatedButton.icon(
                                    label: const Text("Send location"),
                                    icon: const Icon(
                                      Icons.location_pin,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      _serviceEnabled =
                                          await location.serviceEnabled();
                                      if (!_serviceEnabled!) {
                                        _serviceEnabled =
                                            await location.requestService();
                                        if (_serviceEnabled!) {
                                          return;
                                        }
                                      }
                                      _locationData =
                                          await location.getLocation();
                                      setState(() {});
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      category = categorydrop.category;
                                      String imageId =
                                          await uploadImageToFirebase();
                                      fbfs.collection('discrepancies').add(
                                        {
                                          'category': category,
                                          'description': description,
                                          'complainantUid': FirebaseAuth
                                              .instance.currentUser!.uid
                                              .toString(),
                                          'date': Timestamp.now(),
                                          'isResolved': false,
                                          'imageId': imageId,
                                          'location': [
                                            _locationData?.latitude,
                                            _locationData?.longitude
                                          ],
                                        },
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("submit"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
