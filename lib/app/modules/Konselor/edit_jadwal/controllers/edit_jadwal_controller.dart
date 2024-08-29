import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/counseling/models/counseling.dart';
import 'package:url_launcher/url_launcher.dart';

class EditJadwalController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var counselingList = <CounselingSession>[].obs;

  Stream<QuerySnapshot> getAllSchedule() {
    return firestore
        .collection('counselings')
        .where('konselorId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots();
  }

  void updateCounselingList(QuerySnapshot snapshot) {
    counselingList.clear();
    var schedules = snapshot.docs
        .where((doc) => doc['userId'] == "" || doc['userId'] == null)
        .map((doc) => CounselingSession.fromDocument(doc))
        .toList();
    counselingList.addAll(schedules);
  }

  void addSchedule(DateTime jadwal, int durasi, String tautanGmeet) {
    final EditJadwalController scheduleController = Get.find();
    final String konselorId = scheduleController.firebaseAuth.currentUser!.uid;
    final DocumentReference docRef =
        scheduleController.firestore.collection('counselings').doc();

    docRef.set({
      'jadwal': Timestamp.fromDate(jadwal),
      'durasi': durasi,
      'tautanGmeet': tautanGmeet,
      'konselorId': konselorId,
      'userId': '', // Default to empty
    });
  }

  void deleteSchedule(String counselingId) {
    firestore.collection('counselings').doc(counselingId).delete();
  }

  void updateSchedule(
      String id, DateTime jadwal, int durasi, String tautanGmeet) {
    firestore.collection('counselings').doc(id).update({
      'jadwal': Timestamp.fromDate(jadwal),
      'durasi': durasi,
      'tautanGmeet': tautanGmeet,
    });
  }

  Future<void> launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
