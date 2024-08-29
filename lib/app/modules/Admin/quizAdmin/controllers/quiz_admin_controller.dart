import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class QuizAdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addQuiz(String title, String description, List<Map<String, dynamic>> questions) async {
    try {
      // Menambahkan dokumen baru di koleksi quiz
      DocumentReference quizRef = await _firestore.collection('quiz').add({
        'titleQuiz': title,
        'deskripsiQuiz': description,
        'createdAt': Timestamp.now(),
      });

      // Menambahkan 10 dokumen di koleksi question di dalam quiz
      for (var question in questions) {
        await quizRef.collection('question').add(question);
      }

      Get.snackbar('Success', 'Quiz and questions added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add quiz: $e');
    }
  }
}
