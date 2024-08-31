import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../services/notification_manager.dart';

class LoanController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var totalLoan = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    calculateTotalLoan();
  }

  void calculateTotalLoan() {
    firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('loans')
        .snapshots()
        .listen((snapshot) {
      double sum = 0.0;

      for (var doc in snapshot.docs) {
        sum += doc.data()['jumlahPinjaman'] ?? 0.0;
      }

      totalLoan.value = sum;
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listLoans() {
    return firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('loans')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteLoan(String loanId) async {
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('loans')
        .doc(loanId)
        .delete();

    final notificationManager = NotificationManager();
    await notificationManager.deleteLoanNotifications(loanId);

    calculateTotalLoan();

    Get.back();
  }
}
