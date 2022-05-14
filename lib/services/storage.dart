import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
// Orders Images
  Future<void> uploudFile(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('Orders_Images/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> downloadURL(String imageName) async {
    late String downloadURL;
    try {
      downloadURL =
          await storage.ref('Orders_Images/$imageName').getDownloadURL();
    } catch (e) {
      print(e);
      downloadURL = await storage
          .ref('profile_images/no_image_in_firebase.png')
          .getDownloadURL();
    }
    return downloadURL;
  }

//Profile Image uploader
  Future<void> uploudProfileImage(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('profile_images/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> downloadProfileImageURL(String imageName) async {
    late String downloadURL;
    try {
      downloadURL =
          await storage.ref('profile_images/$imageName').getDownloadURL();
    } catch (e) {
      print(e);
      downloadURL = await storage
          .ref('profile_images/No_photo_found.png')
          .getDownloadURL();
      ;
    }
    return downloadURL;
  }
}
