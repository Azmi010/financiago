import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeloan/app/widgets/confirm_show_dialog_widget.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';
import 'dart:io';
import '../../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userData = <String, dynamic>{}.obs;
  var profileImageUrl = ''.obs;

  FirebaseAuth get auth => _auth;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadProfileImage();
  }

  void loadUserData() {
    String uid = _auth.currentUser!.uid;
    _firestore.collection('users').doc(uid).snapshots().listen((userDoc) {
      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
        if (!userData.containsKey('point')) {
          userData['point'] = 0;
        }
      }
    });
  }

  void loadProfileImage() async {
    try {
      String uid = _auth.currentUser!.uid;
      String downloadUrl = await FirebaseStorage.instance
          .ref('profile_images/$uid')
          .getDownloadURL();
      profileImageUrl.value = downloadUrl;
    } catch (e) {
      profileImageUrl.value = '';
    }
  }

  void updateProfileImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        String uid = FirebaseAuth.instance.currentUser!.uid;
        String filePath = 'profile_images/$uid';

        await FirebaseStorage.instance.ref(filePath).putFile(file);

        String downloadUrl =
            await FirebaseStorage.instance.ref(filePath).getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profileImageUrl': downloadUrl,
        });

        profileImageUrl.value = downloadUrl;
        Get.back();
        showDialogInfoWidget(
            "Berhasil mengganti foto profil.", 'succes', context);
      }
    } catch (e) {
      showDialogInfoWidget("Gagal mengganti foto profil.", 'fail', context);
    }
  }

  void deleteAccount(BuildContext context) async {
    confirmShowDialog(
        judul: "Apakah kamu yakin ingin menghapus akun?",
        onPressed: () async {
          Get.back();
          try {
            String uid = FirebaseAuth.instance.currentUser!.uid;
            await FirebaseAuth.instance.currentUser!.delete();
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .delete();
            Get.offAllNamed(Routes.LOGIN);
            showDialogInfoWidget("Berhasil menghapus akun.", 'succes', context);
          } catch (e) {
            showDialogInfoWidget("Gagal menghapus akun.", 'fail', context);
          }
        },
        context: context);
  }

  void logout(BuildContext context) async {
    confirmShowDialog(
        judul: "Apakah kamu ingin Logout?",
        onPressed: () async {
          Get.back();
          try {
            await FirebaseAuth.instance.signOut();
            Get.offAllNamed(Routes.LOGIN);
            showDialogInfoWidget("Berhasil Logout!", 'succes', context);
          } catch (e) {
            showDialogInfoWidget("Gagal Logout!", 'fail', context);
          }
        },
        context: context);
  }

 
}
