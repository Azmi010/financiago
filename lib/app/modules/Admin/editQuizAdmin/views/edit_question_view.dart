import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/Admin/editQuizAdmin/controllers/edit_quiz_admin_controller.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/input_admin_widget.dart';

class EditQuestionView extends StatefulWidget {
  final String quizId;
  final Question question;

  const EditQuestionView({required this.quizId, required this.question, super.key});

  @override
  _EditQuestionViewState createState() => _EditQuestionViewState();
}

class _EditQuestionViewState extends State<EditQuestionView> {
  final questionController = TextEditingController();
  final explanationController = TextEditingController();
  final optionAController = TextEditingController();
  final optionBController = TextEditingController();
  final optionCController = TextEditingController();
  final optionDController = TextEditingController();
  final answerController = TextEditingController();
  final pointController = TextEditingController();
  final controller = Get.find<EditQuizAdminController>();

  @override
  void initState() {
    super.initState();
    questionController.text = widget.question.question;
    explanationController.text = widget.question.explanation;
    optionAController.text = widget.question.options['a'] ?? '';
    optionBController.text = widget.question.options['b'] ?? '';
    optionCController.text = widget.question.options['c'] ?? '';
    optionDController.text = widget.question.options['d'] ?? '';
    answerController.text = widget.question.answer;
    pointController.text = widget.question.point.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBackLeading(),
        title: const Text('Edit Question', style: Utils.header,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            inputAdminWidget(questionController, 'Pertanyaan'),
            inputAdminWidget(explanationController, 'Penjelasan'),
            inputAdminWidget(optionAController, 'Opsi A'),
            inputAdminWidget(optionBController, 'Opsi B'),
            inputAdminWidget(optionCController, 'Opsi C'),
            inputAdminWidget(optionDController, 'Opsi D'),
            inputAdminWidget(answerController, 'Jawaban'),
            inputAdminWidget(pointController, 'Poin'),
            const Spacer(),
            const SizedBox(height: 20),
            ButtonWidget(onPressed: (){controller.updateQuestion(
                  widget.quizId,
                  widget.question.id,
                  questionController.text,
                  explanationController.text,
                  {
                    'a': optionAController.text,
                    'b': optionBController.text,
                    'c': optionCController.text,
                    'd': optionDController.text,
                  },
                  answerController.text,
                  int.parse(pointController.text),
                );
                Get.back();}, nama: "Simpan")
            
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    explanationController.dispose();
    optionAController.dispose();
    optionBController.dispose();
    optionCController.dispose();
    optionDController.dispose();
    answerController.dispose();
    pointController.dispose();
    super.dispose();
  }
}
