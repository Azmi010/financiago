import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/navigation/controllers/navigation_controller.dart';
import 'package:safeloan/app/modules/User/navigation/views/navigation_view.dart';
import 'package:safeloan/app/modules/User/profile/controllers/profile_controller.dart';
import 'package:safeloan/app/widgets/confirm_show_dialog_widget.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var fullNameController = TextEditingController();
  var ageController = TextEditingController();
  var professionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        fullNameController.text = userDoc['fullName'] ?? '';
        ageController.text = userDoc['age']?.toString() ?? '0';
        professionController.text = userDoc['profession'] ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    }
  }

  void saveProfile(BuildContext context) async {
    confirmShowDialog(judul: "Apakah kamu yakin ingin mengupdate profil?", onPressed: () async {
      try {
        String uid = _auth.currentUser!.uid;
        await _firestore.collection('users').doc(uid).update({
          'fullName': fullNameController.text,
          'age': int.parse(ageController.text),
          'profession': professionController.text,
        });
        final ProfileController detailProfileController =
            Get.put(ProfileController());
        detailProfileController.loadUserData();
        detailProfileController.loadProfileImage();
        Get.offAll(
          () => NavigationView(),
          binding: BindingsBuilder(
            () {
              Get.put(NavigationController()).changePage(4);
            },
          ),
        );
        showDialogInfoWidget("Berhasil mengupdate profil.", 'succes', context);
      } catch (e) {
        print('Ini Error: $e');
        showDialogInfoWidget("Gagal mengupdate profil.", 'fail', context);
      }
    }, context: context);
  }
}
