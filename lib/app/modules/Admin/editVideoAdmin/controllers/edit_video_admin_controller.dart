import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditVideoAdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getVideosStream() {
    return firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('videos').snapshots();
  }

  void deleteVideo(String docId) {
    firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('videos').doc(docId).delete();
  }

  void editVideo(String docId, Map<String, dynamic> newData) {
    firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('videos').doc(docId).update(newData);
  }
}