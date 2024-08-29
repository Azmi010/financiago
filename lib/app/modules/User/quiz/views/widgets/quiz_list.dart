import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/quiz/controllers/quiz_controller.dart';
import 'package:safeloan/app/modules/User/quiz/views/widgets/description_quiz_page.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/show_dialog_info_widget.dart';

class QuizList extends GetView<QuizController> {
  const QuizList({super.key});

  Widget cardItem(String title, String deskripsi, String linkGambar,
      bool isCompleted, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Utils.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          title: Text(
            title,
            style: isCompleted
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  )
                : Utils.titleStyle,
          ),
          subtitle: Text(
            deskripsi,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: isCompleted
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black26,
                    fontSize: 12,
                  )
                : Utils.subtitle,
          ),
          trailing: SizedBox(
            width: 75,
            height: 75,
            child: Image.network(
              linkGambar,
              fit: BoxFit.fitHeight,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    QuizController controller = Get.put(QuizController());

    return StreamBuilder<QuerySnapshot>(
      stream: controller.getQuizList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No quizzes found.'));
        }

        controller.updateQuizList(snapshot.data!);

        return Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: controller.quizList.length,
              itemBuilder: (context, index) {
                var quiz = controller.quizList[index];
                bool isCompleted =
                    controller.completedQuizzes.contains(quiz.id);

                return cardItem(
                  quiz.titleQuiz,
                  quiz.deskripsiQuiz,
                  quiz.imageQuiz,
                  isCompleted,
                  () {
                    if (isCompleted) {
                      showDialogInfoWidget(
                          'Quiz sudah dikerjakan', 'fail', context);
                    } else {
                      Get.to(() => DescriptionQuizPage(quiz: quiz));
                    }
                  },
                );
              },
            ),
          );
        });
      },
    );
  }
}
