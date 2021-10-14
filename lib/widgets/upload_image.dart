// // ignore_for_file: file_names

// import 'dart:io';

// // ignore: library_prefixes
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// class UploadImage extends StatefulWidget {
//   const UploadImage({Key? key}) : super(key: key);

//   @override
//   State<UploadImage> createState() => _UploadImageState();
// }

// class _UploadImageState extends State<UploadImage> {
//   FirebaseStorage storage = FirebaseStorage.instance;
//   FirebaseFirestore fbfs = FirebaseFirestore.instance;
//   final picker = ImagePicker();

//   var _imageFile;
//   late int prevImageId ;

  
// Future<int> listExample() async {
//     ListResult result =
//         await FirebaseStorage.instance.ref().listAll();

//     result.items.forEach((Reference ref) {
//         print('Found file: $ref');
//     });

//     result.prefixes.forEach((Reference ref) {
//         print('Found directory: $ref');
//     });
//    return result.items.length;
// }




//   Future pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

    
//       _imageFile = File(pickedFile!.path);
    
//   }


//   Future uploadImageToFirebase() async {
    

    

//     try {
//       await FirebaseStorage.instance
//           .ref(
//               '${await}.png')
//           .putFile(_imageFile);
//     } on FirebaseException catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       label: const Text("Upload Image"),
//       icon: const Icon(
//         Icons.upload_file_outlined,
//         color: Colors.white,
//         size: 20,
        
    
//       ),
//       onPressed: pickImage,
//     );
//   }
// }
