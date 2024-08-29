import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/challange_page/views/challange_page_view.dart';
import 'package:safeloan/app/modules/User/quiz/views/quiz_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/tab_bar_widget.dart';

import '../controllers/tab_quiz_controller.dart';

class TabQuizView extends GetView<TabQuizController> {
  const TabQuizView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Gamifikasi",
            style: Utils.header,
          ),
          centerTitle: true,
        ),
        body: TabBarWidget(
          views: [
            const QuizView(),
            ChallangePageView(),
          ],
          tabLabels: const [
            "Kuis",
            "Tantangan",
          ],
        ),
      ),
    );
  }
}
