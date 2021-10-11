// ignore_for_file: file_names

import 'dart:io';

// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  var _imageFile;
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    _imageFile = File(pickedFile!.path);

    try {
      await FirebaseStorage.instance
          .ref(
              'uploads/file-to-upload${FirebaseAuth.instance.currentUser!.uid.toString()}.png')
          .putFile(_imageFile);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.upload_rounded,
        size: 40,
        color: Colors.white,
      ),
      onPressed: uploadImageToFirebase,
    );
  }
}
