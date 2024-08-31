import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeloan/app/utils/warna.dart';

class SplashView extends StatelessWidget {
  final String nextRoute;

  const SplashView({super.key, required this.nextRoute});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed(nextRoute);
    });

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 5),
            const Text(
              "FinanciaGo",
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
