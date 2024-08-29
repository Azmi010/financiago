import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/modules/User/education/controllers/education_controller.dart';
import 'package:safeloan/app/modules/User/education/views/article_view.dart';
import 'package:safeloan/app/modules/User/education/views/video_view.dart';
import 'package:safeloan/app/utils/warna.dart';
import 'package:safeloan/app/widgets/button_back_leading.dart';
import 'package:safeloan/app/widgets/tab_bar_widget.dart';

class EducationView extends GetView<EducationController> {
  const EducationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Edukasi',
            style: Utils.header,
          ),
          centerTitle: true,
          leading: const ButtonBackLeading()),
      body: const TabBarWidget(
          views: [ArticleWidget(), VideoWidget()],
          tabLabels: ['Artikel', 'Video']),
    );
  }
}
