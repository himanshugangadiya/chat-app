import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/log_in_controller.dart';
import '../helper/internet_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InternetController internetController = Get.put(
    InternetController(),
    permanent: true,
  );
  LogInController logInController = Get.put(LogInController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    internetController.checkRealtimeConnection();
    Future.delayed(
      const Duration(seconds: 3),
      () => logInController.checkCurrentUser(),
    );
  }

  static const colorizeColors = [
    Colors.white,
    Colors.blue,
    Colors.blueAccent,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Chat ON',
                textStyle: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 37),
                speed: const Duration(milliseconds: 250),
                colors: colorizeColors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
