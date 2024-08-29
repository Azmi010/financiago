import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/challange_page/models/challange_model.dart';

class EditChallengeAdminController extends GetxController {
  final challengeTitleC = TextEditingController();
  final challengeSubTitleC = TextEditingController();
  final challengeDescriptionC = TextEditingController();
  final challengePointC = TextEditingController();
  final challengeTargetC = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    final String challengeId = Get.parameters['id'] ?? '';
    if (challengeId.isNotEmpty) {
      fetchChallengeData(challengeId);
    }
  }

  Future<void> fetchChallengeData(String challengeId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('challenges').doc(challengeId).get();
      if (doc.exists) {
        Challenge challenge = Challenge.fromDocument(doc);
        challengeTitleC.text = challenge.title;
        challengeSubTitleC.text = challenge.subTitle;
        challengeDescriptionC.text = challenge.description;
        challengePointC.text = challenge.point.toString();
        challengeTargetC.text = challenge.requiredCount.toString();
      }
    } catch (e) {
      print('Error fetching challenge data: $e');
    }
  }

  Future<void> updateChallenge(String challengeId) async {
    try {
      await _firestore.collection('challenges').doc(challengeId).update({
        'title': challengeTitleC.text,
        'subTitle': challengeSubTitleC.text,
        'description': challengeDescriptionC.text,
        'point': int.parse(challengePointC.text),
        'requiredCount': int.parse(challengeTargetC.text),
        // Add other fields if needed
      });
    } catch (e) {
      print('Error updating challenge data: $e');
    }
  }
}
