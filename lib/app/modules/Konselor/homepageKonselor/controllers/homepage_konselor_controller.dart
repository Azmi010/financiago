import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/counseling/models/counseling.dart';

class HomepageKonselorController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var counselingList = <CounselingSessionWithUserData>[].obs;

  Stream<List<CounselingSessionWithUserData>> getUpcomingMeeting() {
    return firestore
        .collection('counselings')
        .where('konselorId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<CounselingSessionWithUserData> sessions = [];
      for (var doc in snapshot.docs) {
        if (doc['userId'] != "" && doc['userId'] != null) {
          CounselingSession counseling = CounselingSession.fromDocument(doc);
          DocumentSnapshot userDoc =
              await firestore.collection('users').doc(counseling.userId).get();
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          sessions.add(CounselingSessionWithUserData(
              counseling: counseling, userData: userData));
        }
      }
      return sessions;
    });
  }

  void updateCounselingList(List<CounselingSessionWithUserData> sessions) {
    counselingList.clear();
    counselingList.addAll(sessions);
  }

  
}
