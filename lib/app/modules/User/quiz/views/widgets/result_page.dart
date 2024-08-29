import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/quiz/controllers/quiz_controller.dart';
import 'package:safeloan/app/modules/User/navigation/views/navigation_view.dart';
import 'package:safeloan/app/modules/User/tab_quiz/views/tab_quiz_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_widget.dart';

class ResultPage extends GetView<QuizController> {
  final String quizId;
  const ResultPage({super.key, required this.quizId});
  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find<QuizController>();
    quizController.fetchQuizResult(quizId);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Kuis',
          style: Utils.header,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selamat Anda Mendapatkan Reward',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Utils.backgroundCard,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            final point =
                                quizController.quizResult['point'] ?? 0;
                            final coin = quizController.quizResult['coin'] ?? 0;
                            return Text(
                              '$point Poin & $coin Coin',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Utils.biruSatu,
                              ),
                              textAlign: TextAlign.center,
                            );
                          })
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ButtonWidget(
              nama: 'Kembali ke Beranda',
              colorBackground: Utils.biruDua,
              onPressed: () {
                Get.offAll(() => const NavigationView());
              },
            ),
            const SizedBox(height: 25),
            ButtonWidget(
              nama: 'Coba Kuis Lain',
              colorBackground: Utils.backgroundCard,
              colorText: Utils.biruSatu,
              onPressed: () {
                Get.off(() => const TabQuizView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
