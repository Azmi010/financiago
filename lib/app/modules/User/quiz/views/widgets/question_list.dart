import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/quiz/controllers/quiz_controller.dart';
import 'package:safeloan/app/modules/User/quiz/views/widgets/result_page.dart';
import 'package:safeloan/app/utils/warna.dart';

class QuestionList extends GetView<QuizController> {
  final String quizId;

  const QuestionList({super.key, required this.quizId});

  Widget button(Icon icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(25),
      width: 80,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Utils.biruDua,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.put(QuizController());
    final PageController pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pertanyaan'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: quizController.getQuestionList(quizId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          quizController.updateQuestionList(snapshot.data!);

          return Obx(() {
            return PageView.builder(
              controller: pageController,
              itemCount: quizController.questionList.length,
              itemBuilder: (context, index) {
                var question = quizController.questionList[index];
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Utils.backgroundCard,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              question.pertanyaan,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: question.opsiJawaban.entries.map((entry) {
                              return Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    quizController.selectAnswer(index, entry.key);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: quizController.selectedAnswers[index] == entry.key
                                          ? Utils.biruTiga
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Utils.biruTiga),
                                    ),
                                    child: Center(
                                      child: Text(
                                        entry.value,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: quizController.selectedAnswers[index] == entry.key
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }).toList(),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (index > 0)
                                button(
                                  const Icon(Icons.keyboard_arrow_left,
                                      color: Colors.white),
                                  () {
                                    pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                )
                              else
                                const SizedBox(width: 80),
                              if (index <
                                  quizController.questionList.length - 1)
                                button(
                                  const Icon(Icons.keyboard_arrow_right,
                                      color: Colors.white),
                                  () {
                                    pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                )
                              else if (index ==
                                  quizController.questionList.length - 1)
                                button(
                                  const Icon(Icons.save, color: Colors.white),
                                  () async {
                                    await quizController.checkAnswer(quizId);
                                    Get.off(ResultPage(quizId: quizId));
                                    print('Save button pressed');
                                  },
                                )
                              else
                                const SizedBox(width: 80),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          });
        },
      ),
    );
  }
}
