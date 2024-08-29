import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChallengeAdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChallengeStream() {
    return firestore.collection('challenges').snapshots();
  }
}
