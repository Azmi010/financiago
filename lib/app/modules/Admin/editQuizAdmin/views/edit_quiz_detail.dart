import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/Admin/editQuizAdmin/controllers/edit_quiz_admin_controller.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';
import 'package:safeloan/app/widgets/input_admin_widget.dart';

class EditQuizView extends StatefulWidget {
  final Quiz quiz;

  const EditQuizView({required this.quiz, super.key});

  @override
  _EditQuizViewState createState() => _EditQuizViewState();
}

class _EditQuizViewState extends State<EditQuizView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final controller = Get.find<EditQuizAdminController>();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.quiz.title;
    descriptionController.text = widget.quiz.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBackLeading(),
        title: const Text('Edit Kuis', style: Utils.header),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            inputAdminWidget(titleController, 'Judul'),
            inputAdminWidget(descriptionController, 'Deskripsi'),
            const Spacer(),
            ButtonWidget(onPressed: (){
              controller.updateQuiz(
                  widget.quiz.id,
                  titleController.text,
                  descriptionController.text,
                );
                Get.back();
            }, nama: "Simpan")
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

