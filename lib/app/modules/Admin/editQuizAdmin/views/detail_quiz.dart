import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/Admin/editQuizAdmin/controllers/edit_quiz_admin_controller.dart';
import 'package:safeloan/app/modules/Admin/editQuizAdmin/views/edit_question_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';

class QuizDetailView extends StatelessWidget {
  final Quiz quiz;

  const QuizDetailView({required this.quiz, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBackLeading(),
        title: Text(quiz.title, style: Utils.header),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: quiz.questions.length,
        itemBuilder: (context, index) {
          var question = quiz.questions[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 0.6, horizontal: 5),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Utils.backgroundCard,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  question.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Answer: ${question.answer}'),
                    Text(
                      'Explanation: ${question.explanation}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => Get.to(() =>
                      EditQuestionView(quizId: quiz.id, question: question)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
