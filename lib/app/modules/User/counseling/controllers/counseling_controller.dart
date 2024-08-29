import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeloan/app/modules/User/counseling/models/counseling.dart';
import 'package:url_launcher/url_launcher.dart';

class CounselingController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var counselingSession = Rxn<CounselingSessionWithUserData>();
  var counselingList = <CounselingSessionWithUserData>[].obs;

  Stream<List<CounselingSessionWithUserData>> getListKonseling() {
    return firestore
        .collection('counselings')
        .where('userId', isEqualTo: "")
        .snapshots()
        .asyncMap((snapshot) async {
      List<CounselingSessionWithUserData> sessions = [];
      for (var doc in snapshot.docs) {
        CounselingSession counseling = CounselingSession.fromDocument(doc);
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(counseling.konselorId)
            .get();
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        sessions.add(CounselingSessionWithUserData(
            counseling: counseling, userData: userData));
      }
      return sessions;
    });
  }

  void updateCounselingList(List<CounselingSessionWithUserData> sessions) {
    counselingList.clear();
    counselingList.addAll(sessions);
  }

  Stream<CounselingSessionWithUserData?> getCounselingSession() {
    return firestore
        .collection('counselings')
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      var doc = snapshot.docs.first;
      CounselingSession counseling = CounselingSession.fromDocument(doc);
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(counseling.konselorId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return CounselingSessionWithUserData(
          counseling: counseling, userData: userData);
    });
  }

  void updateCounselingSession(CounselingSessionWithUserData? session) {
    counselingSession.value = session;
  }

  Future<void> launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
