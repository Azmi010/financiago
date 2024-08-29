import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    fetchNotifications(currentUserId);
  }

  void fetchNotifications(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('notifications')
          .where('userId',
              isEqualTo: userId).orderBy('createdAt', descending: true)
          .get();

      var data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      notifications.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications');
    }
  }
}
