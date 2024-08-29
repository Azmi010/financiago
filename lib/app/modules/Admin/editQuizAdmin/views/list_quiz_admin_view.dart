import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/Admin/editQuizAdmin/views/detail_quiz.dart';
import 'package:safeloan/app/modules/Admin/editQuizAdmin/views/edit_quiz_detail.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import '../controllers/edit_quiz_admin_controller.dart';

class ListQuizAdminView extends GetView<EditQuizAdminController> {
  const ListQuizAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    EditQuizAdminController controller = Get.put(EditQuizAdminController());
    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBackLeading(),
        title: const Text('Daftar Kuis', style: Utils.header),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.quizzes.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: controller.quizzes.length,
          itemBuilder: (context, index) {
            var quiz = controller.quizzes[index];
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
                    quiz.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    quiz.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Get.to(() => EditQuizView(quiz: quiz)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteQuiz(quiz.id),
                      ),
                    ],
                  ),
                  onTap: () => Get.to(() => QuizDetailView(quiz: quiz)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
