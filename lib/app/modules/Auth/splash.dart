import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';

class SplashView extends StatelessWidget {
  final String nextRoute;

  const SplashView({Key? key, required this.nextRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memulai delay saat widget dibangun
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed(nextRoute);
    });

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/loading_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
            ),
            const Text(
              "Kelola.In",
              style: TextStyle(
                color: Utils.biruSatu,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
