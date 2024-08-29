import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PengeluaranController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;

  var expenseList = <Map<String, dynamic>>[].obs;
  var totalExpenses = 0.0.obs;
  var selectedFilter = 'Semua Data'.obs; 

  @override
  void onInit() {
    super.onInit();
    listenToExpenseData();
  }

  void listenToExpenseData() {
    String uid = _auth.currentUser!.uid;
    CollectionReference expenseCollection = _firestore
        .collection('finances')
        .doc(uid)
        .collection('expense');

    expenseCollection.snapshots().listen((snapshot) {
      var expenseDocs = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate();
        }
        data['docId'] = doc.id; 
        return data;
      }).toList();

      expenseDocs.sort((a, b) {
        DateTime dateA = a['date'] is DateTime ? a['date'] as DateTime : DateTime.parse(a['date'].toString());
        DateTime dateB = b['date'] is DateTime ? b['date'] as DateTime : DateTime.parse(b['date'].toString());
        return dateB.compareTo(dateA); 
      });

      List<Map<String, dynamic>> filteredDocs = _filterData(expenseDocs);

      expenseList.value = filteredDocs;
      totalExpenses.value = filteredDocs.fold(0.0, (sum, item) => sum + (item['nominal'] as num).toDouble());
    });
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data) {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedFilter.value) {
      case 'Harian':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Mingguan':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Bulanan':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Tahunan':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        return data;
    }

    return data.where((item) {
      DateTime itemDate = item['date'] is DateTime ? item['date'] as DateTime : DateTime.parse(item['date'].toString());
      return itemDate.isAfter(startDate);
    }).toList();
  }
}
