import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonBackLeading extends StatelessWidget {
  const ButtonBackLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios));
  }
}
