import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import '../controllers/quiz_admin_controller.dart';

class QuizAdminView extends GetView<QuizAdminController> {
  const QuizAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final questionControllers = <Map<String, TextEditingController>>[].obs;

    void addQuestion() {
      questionControllers.add({
        'question': TextEditingController(),
        'explanation': TextEditingController(),
        'optionA': TextEditingController(),
        'optionB': TextEditingController(),
        'optionC': TextEditingController(),
        'optionD': TextEditingController(),
        'answer': TextEditingController(),
        'point': TextEditingController(text: '10'),
      });
    }

    addQuestion();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz', style: Utils.header,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Quiz Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Utils.biruSatu,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Quiz Title',
                          prefixIcon:
                              const Icon(Icons.title, color: Utils.biruDua),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Quiz Description',
                          prefixIcon: const Icon(Icons.description,
                              color: Utils.biruDua),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => Column(
                    children: [
                      ...questionControllers.asMap().entries.map((entry) {
                        int index = entry.key;
                        var controllerMap = entry.value;
                        return Card(
                          elevation: 3,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ExpansionTile(
                            title: Text('Question ${index + 1}'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: controllerMap['question'],
                                      decoration: InputDecoration(
                                        labelText: 'Question',
                                        prefixIcon: const Icon(Icons.help,
                                            color: Utils.biruDua),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: controllerMap['explanation'],
                                      decoration: InputDecoration(
                                        labelText: 'Explanation',
                                        prefixIcon: const Icon(Icons.info,
                                            color: Utils.biruDua),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ...['A', 'B', 'C', 'D']
                                        .map((option) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: TextField(
                                                controller: controllerMap[
                                                    'option$option'],
                                                decoration: InputDecoration(
                                                  labelText: 'Option $option',
                                                  prefixIcon: const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Utils.biruDua),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    TextField(
                                      controller: controllerMap['answer'],
                                      decoration: InputDecoration(
                                        labelText: 'Correct Answer',
                                        prefixIcon: const Icon(Icons.check,
                                            color: Utils.biruDua),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: controllerMap['point'],
                                      decoration: InputDecoration(
                                        labelText: 'Point',
                                        prefixIcon: const Icon(Icons.stars,
                                            color: Utils.biruDua),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      ButtonWidget(
                        onPressed: addQuestion,
                        nama: "Add New Question",
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              ButtonWidget(
                onPressed: () {
                  final questions = questionControllers.map((controllerMap) {
                    return {
                      'pertanyaan': controllerMap['question']?.text,
                      'penjelasan': controllerMap['explanation']?.text,
                      'opsiJawaban': {
                        'a': controllerMap['optionA']?.text,
                        'b': controllerMap['optionB']?.text,
                        'c': controllerMap['optionC']?.text,
                        'd': controllerMap['optionD']?.text,
                      },
                      'jawaban': controllerMap['answer']?.text,
                      'point': int.parse(controllerMap['point']?.text ?? '10'),
                    };
                  }).toList();

                  controller.addQuiz(
                    titleController.text,
                    descriptionController.text,
                    questions,
                  );
                },
                nama: "Save Quiz",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
