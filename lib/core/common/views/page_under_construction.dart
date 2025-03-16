import 'package:attendance_management/core/common/widgets/gradient_background.dart'
    show GradientBackground;
import 'package:attendance_management/core/res/media_res.dart' show MediaRes;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' show Lottie;

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: MediaRes.onBoardingBackground,
        child: Lottie.asset(MediaRes.pageUnderConstruction),
      ),
    );
  }
}
