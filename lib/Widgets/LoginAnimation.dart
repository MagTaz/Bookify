import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginAnimation extends StatelessWidget {
  const LoginAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, index) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: Lottie.asset(
              "assets/animation/LoginAnimation.json",
              repeat: true,

              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
