import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/quiz/models/quiz_model.dart';

class QuizController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  var quizList = <Quiz>[].obs;
  var questionList = <Question>[].obs;
  var selectedAnswers = <String?>[].obs;
  var score = 0.obs;
  var totalCoins = 0.obs; // Tambahkan ini
  var quizResult = {}.obs;
  var completedQuizzes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ganti fetchCompletedQuizzes dengan pemantauan real-time
    getCompletedQuizzes().listen((completedQuizIds) {
      completedQuizzes.assignAll(completedQuizIds);
    });
  }

  Stream<QuerySnapshot> getQuizList() {
    return firestore.collection('quiz').snapshots();
  }

  void updateQuizList(QuerySnapshot snapshot) {
    quizList.clear();
    quizList.addAll(snapshot.docs.map((doc) => Quiz.fromDocument(doc)).toList());
  }

  Stream<QuerySnapshot> getQuestionList(String quizId) {
    return firestore
        .collection('quiz')
        .doc(quizId)
        .collection('question')
        .snapshots();
  }

  void updateQuestionList(QuerySnapshot snapshot) {
    questionList.clear();
    questionList.addAll(
        snapshot.docs.map((doc) => Question.fromDocument(doc)).toList());
    selectedAnswers.assignAll(List<String?>.filled(questionList.length, null));
  }

  void selectAnswer(int index, String answer) {
    selectedAnswers[index] = answer;
    selectedAnswers.refresh();
  }

  Future<void> checkAnswer(String quizId) async {
    print('checkAnswer called');
    score.value = 0;
    totalCoins.value = 0;  // Reset totalCoins

    for (int i = 0; i < questionList.length; i++) {
      if (selectedAnswers[i] == questionList[i].jawaban) {
        score.value += questionList[i].poin;
        totalCoins.value += questionList[i].coin;  // Tambahkan ini
      }
    }

    print('Total Score: ${score.value}');
    print('Total Coins: ${totalCoins.value}');  // Tambahkan ini
    await saveResult(quizId);
  }

  Future<void> saveResult(String quizId) async {
    await firestore.collection('quizResult').add({
      'finishAt': DateTime.now(),
      'quizId': quizId,
      'point': score.value,
      'coin': totalCoins.value,  // Tambahkan ini
      'userId': firebaseAuth.currentUser!.uid
    });
    print('Result saved');
    await updateUserPointsAndCoins(); // Tambahkan ini
    // fetchCompletedQuizzes(); // Hapus panggilan ini karena sudah ada stream
    fetchQuizResult(quizId);
  }

  Future<void> updateUserPointsAndCoins() async {
    DocumentReference userRef = firestore.collection('users').doc(firebaseAuth.currentUser!.uid);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      int currentPoints = userDoc['point'];
      int currentCoins = userDoc['coin'];

      await userRef.update({
        'point': currentPoints + score.value,
        'coin': currentCoins + totalCoins.value,
      });
      print('User points and coins updated');
    } else {
      print('User document does not exist');
    }
  }

  Stream<List<String>> getCompletedQuizzes() {
    return firestore
        .collection('quizResult')
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc['quizId'] as String).toList());
  }

  void fetchQuizResult(String quizId) async {
    final resultSnapshot = await firestore
        .collection('quizResult')
        .where('quizId', isEqualTo: quizId)
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy('finishAt', descending: true)
        .limit(1)
        .get();

    if (resultSnapshot.docs.isNotEmpty) {
      quizResult.value = resultSnapshot.docs.first.data();
    }
  }
}
