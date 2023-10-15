import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/screens/authentication/login_screen.dart';
import 'package:chat_app/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkCurrentUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () => checkCurrentUser(),
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
