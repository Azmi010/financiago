import 'package:flutter/material.dart';
import 'package:safeloan/app/modules/User/education/views/article_view.dart';

class ArtikelTopBar extends StatelessWidget {
  const ArtikelTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const ArticleWidget(),
    );
  }
}