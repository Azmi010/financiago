import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuizAdminController extends GetxController {
  var quizzes = <Quiz>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  void fetchQuizzes() async {
    var quizCollection = await FirebaseFirestore.instance.collection('quiz').get();
    for (var doc in quizCollection.docs) {
      var quiz = Quiz.fromDocument(doc);
      quiz.questions = await fetchQuestions(doc.id);
      quizzes.add(quiz);
    }
  }

  Future<List<Question>> fetchQuestions(String quizId) async {
    var questions = <Question>[];
    var questionCollection = await FirebaseFirestore.instance.collection('quiz/$quizId/question').get();
    for (var doc in questionCollection.docs) {
      questions.add(Question.fromDocument(doc));
    }
    return questions;
  }

  void deleteQuiz(String quizId) async {
    await FirebaseFirestore.instance.collection('quiz').doc(quizId).delete();
    quizzes.removeWhere((quiz) => quiz.id == quizId);
  }

  void updateQuiz(String quizId, String newTitle, String newDescription) async {
    await FirebaseFirestore.instance.collection('quiz').doc(quizId).update({
      'titleQuiz': newTitle,
      'deskripsiQuiz': newDescription,
    });
    var quiz = quizzes.firstWhere((quiz) => quiz.id == quizId);
    quiz.title = newTitle;
    quiz.description = newDescription;
    quizzes.refresh();
  }

  void updateQuestion(String quizId, String questionId, String newQuestion, String newExplanation, Map<String, String> newOptions, String newAnswer, int newPoint) async {
    await FirebaseFirestore.instance.collection('quiz/$quizId/question').doc(questionId).update({
      'pertanyaan': newQuestion,
      'penjelasan': newExplanation,
      'opsiJawaban': newOptions,
      'jawaban': newAnswer,
      'point': newPoint,
    });
    var quiz = quizzes.firstWhere((quiz) => quiz.id == quizId);
    var question = quiz.questions.firstWhere((q) => q.id == questionId);
    question.question = newQuestion;
    question.explanation = newExplanation;
    question.options = newOptions;
    question.answer = newAnswer;
    question.point = newPoint;
    quizzes.refresh();
  }
}

class Quiz {
  String id;
  String title;
  String description;
  DateTime createdAt;
  List<Question> questions;

  Quiz({required this.id, required this.title, required this.description, required this.createdAt, required this.questions});

  factory Quiz.fromDocument(DocumentSnapshot doc) {
    return Quiz(
      id: doc.id,
      title: doc['titleQuiz'],
      description: doc['deskripsiQuiz'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      questions: [],
    );
  }
}

class Question {
  String id;
  String question;
  String explanation;
  Map<String, String> options;
  String answer;
  int point;

  Question({required this.id, required this.question, required this.explanation, required this.options, required this.answer, required this.point});

  factory Question.fromDocument(DocumentSnapshot doc) {
    return Question(
      id: doc.id,
      question: doc['pertanyaan'],
      explanation: doc['penjelasan'],
      options: Map<String, String>.from(doc['opsiJawaban']),
      answer: doc['jawaban'],
      point: doc['point'],
    );
  }
}
