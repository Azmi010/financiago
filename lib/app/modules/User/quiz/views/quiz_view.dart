// views/quiz_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/quiz/controllers/quiz_controller.dart';
import 'package:safeloan/app/modules/User/quiz/views/widgets/quiz_list.dart';
import 'package:safeloan/app/modules/User/tab_quiz/views/leaderboard.dart';
import 'package:safeloan/app/utils/warna.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const QuizList(),
          Positioned(
            bottom: 20,
            right: 18,
            child: FloatingActionButton(
              onPressed: () {
                Get.to(LeaderBoard());
              },
              backgroundColor: Utils.biruLima,
              child: const Icon(
                Icons.leaderboard,
                color: Utils.biruDua,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
