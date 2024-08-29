import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EducationAdminController extends GetxController {
  final String educationDocId = "q02NZjM7bwuOI9RDM226";

  // Articles
  TextEditingController articleTitleC = TextEditingController();
  TextEditingController articleContentC = TextEditingController();
  TextEditingController articleSourceC = TextEditingController();
  Rxn<XFile> articleImage = Rxn<XFile>();

  // Videos
  TextEditingController videoTitleC = TextEditingController();
  TextEditingController videoDescriptionC = TextEditingController();
  TextEditingController videoLinkC = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      articleImage.value = image;
    }
  }

  Future<void> addArticle() async {
  bool? confirm = await Get.defaultDialog<bool>(
    title: "Confirmation",
    content: const Column(
      children: [
        Icon(Icons.warning_amber, color: Colors.orange, size: 50),
        SizedBox(height: 10),
        Text("Are you sure you want to add this article?"),
      ],
    ),
    textConfirm: "Yes",
    textCancel: "No",
    onConfirm: () => Get.back(result: true),
    onCancel: () => Get.back(result: false),
    confirmTextColor: Colors.white,
    buttonColor: Colors.green,
    cancelTextColor: Colors.red,
    radius: 10,
    barrierDismissible: false,
  );

  if (confirm == true) {
    if (articleImage.value == null) {
      Get.snackbar("Error", "Please upload an image");
      return;
    }
    try {
      final String imageUrl = await _uploadImage(articleImage.value!);
      await firestore
          .collection('educations')
          .doc(educationDocId)
          .collection('articles')
          .add({
        'title': articleTitleC.text,
        'content': articleContentC.text,
        'source': articleSourceC.text,
        'image': imageUrl,
        'postAt': Timestamp.now(),
      });
      Get.snackbar("Success", "Article added successfully");
      clearArticleFields();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}


  Future<void> addVideo() async {
    bool confirm = await Get.defaultDialog(
      title: "Confirmation",
      middleText: "Are you sure you want to add this video?",
      textConfirm: "Yes",
      textCancel: "No",
    );

    if (!confirm) return;

    try {
      await firestore
          .collection('educations')
          .doc(educationDocId)
          .collection('videos')
          .add({
        'title': videoTitleC.text,
        'description': videoDescriptionC.text,
        'link': videoLinkC.text,
        'postAt': Timestamp.now(),
      });
      Get.snackbar("Success", "Video added successfully");
      clearVideoFields();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<String> _uploadImage(XFile image) async {
    Reference ref = storage.ref().child('articles').child(DateTime.now().toString() + "_" + image.name);
    UploadTask uploadTask = ref.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  void clearArticleFields() {
    articleTitleC.clear();
    articleContentC.clear();
    articleSourceC.clear();
    articleImage.value = null;
  }

  void clearVideoFields() {
    videoTitleC.clear();
    videoDescriptionC.clear();
    videoLinkC.clear();
  }

  @override
  void onClose() {
    articleTitleC.dispose();
    articleContentC.dispose();
    articleSourceC.dispose();
    videoTitleC.dispose();
    videoDescriptionC.dispose();
    videoLinkC.dispose();
    super.onClose();
  }
}
