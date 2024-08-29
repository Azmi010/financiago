import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var incomeTotalsByCategory = <String, double>{}.obs;
  var expenseTotalsByCategory = <String, double>{}.obs;

  FirebaseAuth get auth => _auth;

  @override
  void onInit() {
    fetchTodayData();
    super.onInit();
  }

  void fetchTodayData() async {
    String uid = _auth.currentUser!.uid;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final incomeQuery = FirebaseFirestore.instance
        .collection('finances')
        .doc(uid) 
        .collection('income')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay);

    final expenseQuery = FirebaseFirestore.instance
        .collection('finances')
        .doc(uid) 
        .collection('expense')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay);

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
