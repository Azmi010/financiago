import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

class DetailFinanceController extends GetxController {
  var financeData = <String, dynamic>{}.obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxString docId = ''.obs;
  final RxString type = ''.obs; // 'income' or 'expense'

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;

    docId.value = arguments?['docId'] ?? '';
    type.value = arguments?['type'] ?? '';

    if (docId.value.isNotEmpty && type.value.isNotEmpty) {
      fetchFinanceData(docId.value, type.value);
    } else {
      Get.snackbar('Error', 'Invalid finance ID or type');
    }
  }

  void fetchFinanceData(String id, String type) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore
          .collection('finances')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(type)
          .doc(id)
          .get();

      if (doc.exists) {
        financeData.value = {
          'title': doc.data()?['title'] ?? 'N/A',
          'nominal': doc.data()?['nominal'] ?? 0.0,
          'date':
              (doc.data()?['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'notes': doc.data()?['notes'] ?? 'N/A',
          'category': doc.data()?['category'] ?? 'N/A',
        };
      } else {
        Get.snackbar('Error', 'Finance data not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch finance data: $e');
    }
  }

  Future<void> updateFinanceData(String docId, String type,
      Map<String, dynamic> updatedData, BuildContext context) async {
    try {
      await firestore
          .collection('finances')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(type)
          .doc(docId)
          .update({
        'title': updatedData['title'],
        'nominal': updatedData['nominal'],
        'notes': updatedData['notes'],
      });
      Get.back();
      showDialogInfoWidget(
          'Berhasil mengupdate data keuangan', 'succes', context);
    } catch (e) {
      showDialogInfoWidget('Gagal mengupdate data keuangan', 'fail', context);
    }
  }

  Future<void> deleteFinanceData(
      String docId, String type, BuildContext context) async {
    if (docId.isEmpty || type.isEmpty) {
      Get.snackbar('Error', 'Invalid finance ID or type');
      return;
    }

    try {
      await firestore
          .collection('finances')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(type)
          .doc(docId)
          .delete();
      Get.back();

      showDialogInfoWidget(
          'Berhasil menghapus data keuangan', 'succes', context);
    } catch (e) {
      showDialogInfoWidget('Gagal mengupdate data keuangan', 'fail', context);
    }
  }
}
