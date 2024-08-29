import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeeklyController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var incomeTotalsByCategory = <String, double>{}.obs;
  var expenseTotalsByCategory = <String, double>{}.obs;

  @override
  void onInit() {
    fetchWeeklyData();
    super.onInit();
  }

  void fetchWeeklyData() async {
    String uid = _auth.currentUser!.uid;
    final now = DateTime.now();
    final startOfWeek =
        now.subtract(const Duration(days: 7)); 
    final endOfWeek = now;

    final incomeQuery = FirebaseFirestore.instance
        .collection('finances')
        .doc(uid)
        .collection('income')
        .where('date', isGreaterThanOrEqualTo: startOfWeek)
        .where('date', isLessThan: endOfWeek);

    final expenseQuery = FirebaseFirestore.instance
        .collection('finances')
        .doc(uid)
        .collection('expense')
        .where('date', isGreaterThanOrEqualTo: startOfWeek)
        .where('date', isLessThan: endOfWeek);

    incomeQuery.snapshots().listen((snapshot) {
      var incomeTotals = <String, double>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final category = data['category'] as String;
        final nominal = data['nominal'] as double;
        incomeTotals[category] = (incomeTotals[category] ?? 0) + nominal;
      }
      incomeTotalsByCategory.assignAll(incomeTotals);
    });

    expenseQuery.snapshots().listen((snapshot) {
      var expenseTotals = <String, double>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final category = data['category'] as String;
        final nominal = data['nominal'] as double;
        expenseTotals[category] = (expenseTotals[category] ?? 0) + nominal;
      }
      expenseTotalsByCategory.assignAll(expenseTotals);
    });
  }
}
