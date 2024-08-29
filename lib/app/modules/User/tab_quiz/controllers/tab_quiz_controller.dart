import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TabQuizController extends GetxController {
  //TODO: Implement TabQuizController
  
Future<List<Map<String, dynamic>>> fetchLeaderboardData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('point', descending: true)
        .limit(100)  // Adjust the limit as needed
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'name': doc['fullName'],
        'points': doc['point'],
      };
    }).toList();
  }
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
