import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: LoadingAnimationWidget.inkDrop(
              color: Colors.white,
              size: 200,
            ),
          ),
        ),
      ),
    );
  }
}
