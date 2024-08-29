import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeloan/app/routes/app_pages.dart';

class HomepageAdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  Stream<QuerySnapshot> getArticlesStream() {
    return firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('articles').snapshots();
  }
  
  Stream<QuerySnapshot> getVideosStream() {
    return firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('videos').snapshots();
  }
  
  void deleteArticle(String docId) {
    firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('articles').doc(docId).delete();
  }
  
  void deleteVideo(String docId) {
    firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('videos').doc(docId).delete();
  }
  
  void editArticle(String docId, Map<String, dynamic> newData) {
    firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('articles').doc(docId).update(newData);
  }
  
  void editVideo(String docId, Map<String, dynamic> newData) {
    firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('videos').doc(docId).update(newData);
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
    Get.defaultDialog(
      title: "Logout",
      middleText: "Berhasil Logout",
    );
  }
}
