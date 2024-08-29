import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditArticleAdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getArticlesStream() {
    return firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('articles').snapshots();
  }

  void deleteArticle(String docId) {
    firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('articles').doc(docId).delete();
  }

  void editArticle(String docId, Map<String, dynamic> newData) {
    firestore.collection('educations').doc('q02NZjM7bwuOI9RDM226').collection('articles').doc(docId).update(newData);
  }
}
