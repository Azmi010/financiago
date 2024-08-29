import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DetailLoanController extends GetxController {
  var loanData = <String, dynamic>{}.obs;  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    String loanId = Get.arguments as String;  
    fetchLoanData(loanId);
  }

  void fetchLoanData(String loanId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('loans')
          .doc(loanId)
          .get();

      if (doc.exists) {
        loanData.value = doc.data()!;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch loan data: $e');
    }
  }
}
