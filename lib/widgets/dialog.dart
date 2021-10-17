// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmc/widgets/category_dropdown.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewDiscrepancyPopup extends StatefulWidget {
  const NewDiscrepancyPopup({Key? key}) : super(key: key);

  @override
  _NewDiscrepancyPopupState createState() => _NewDiscrepancyPopupState();
}

class _NewDiscrepancyPopupState extends State<NewDiscrepancyPopup> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = FirebaseStorage.instance.ref('/notes.txt');
  var category = '';

  CategoryDropdown categorydrop = CategoryDropdown();
  String showcategory = "All";
  bool _isLoading = false;
  var description = '';
  String vehicleNo = '';
  Location location = Location();
  File? imageFile;
  String dropdownValue = "";
  bool? _serviceEnabled;

  // PermissionStatus? _permissionGranted;

  LocationData? _locationData;

  FirebaseAuth fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore fbfs = FirebaseFirestore.instance;
  final picker = ImagePicker();

  Future<int> getImagesLength() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();
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
      await storage.ref(imageId).putFile(imageFile!);
    // ignore: empty_catches
    } on FirebaseException {
      
    }
    return imageId;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Submit Discrepancies"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            categorydrop,
            TextField(
              decoration: const InputDecoration(hintText: "Description"),
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
                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled!) {
                  _serviceEnabled = await location.requestService();
                  if (_serviceEnabled!) {
                    return;
                  }
                }
                _locationData = await location.getLocation();
                setState(() {});
              },
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      category = categorydrop.category;
                      String imageId = await uploadImageToFirebase();
                      await fbfs.collection('discrepancies').add(
                        {
                          'category': category,
                          'description': description,
                          'complainantUid':
                              FirebaseAuth.instance.currentUser!.uid.toString(),
                          'date': Timestamp.now(),
                          'isResolved': false,
                          'imageId': imageId,
                          'location': [
                            _locationData?.latitude,
                            _locationData?.longitude
                          ],
                        },
                      );
                      setState(() {
                        _isLoading = false;
                      });

                      Navigator.of(context).pop();
                    },
                    child: const Text("submit"),
                  ),
          ],
        ),
      ),
    );
  }
}
