import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/quiz/models/quiz_model.dart';
import 'package:safeloan/app/modules/User/quiz/views/widgets/question_list.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/button_widget.dart';

class DescriptionQuizPage extends StatelessWidget {
  const DescriptionQuizPage({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kuis Keuangan',
          style: Utils.header,
        ),
        centerTitle: true,
        leading: const ButtonBackLeading(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 186,
                  height: 145,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(quiz.imageQuiz),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                quiz.titleQuiz,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(quiz.deskripsiQuiz),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoColumn("10", "Soal"),
                  _buildInfoColumn("10", "Menit"),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                "Deskripsi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Selamat datang di Kuis Manajemen Keuangan Pribadi! Kuis ini dirancang untuk membantu Anda memahami dan mengasah keterampilan manajemen keuangan Anda. Melalui serangkaian pertanyaan interaktif, Anda akan belajar tentang konsep dasar keuangan, seperti anggaran, tabungan, investasi, dan pengelolaan utang.",
                style: TextStyle(color: Color.fromARGB(255, 151, 151, 151)),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 25),
              Center(
                child: ButtonWidget(
                  onPressed: () {
                    Get.offAll(() => QuestionList(quizId: quiz.id));
                  },
                  nama: "Mulai Kuis",
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ButtonWidget(
                  onPressed: () {
                    Get.back();
                  },
                  nama: "Kerjakan Kuis Lain",
                  colorBackground: Utils.biruLima,
                  colorText: Utils.biruSatu,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: 90,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
