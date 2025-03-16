import 'package:attendance_management/core/common/widgets/gradient_background.dart';
import 'package:attendance_management/core/res/media_res.dart' show MediaRes;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      image: MediaRes.onBoardingBackground,
      child: const Placeholder(),
    );
  }
}
