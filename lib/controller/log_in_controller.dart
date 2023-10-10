import 'package:chat_app/utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/home/home_screen.dart';

class LoginInController extends GetxController {
  logIn({required String email, required String password}) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: email.toString(),
            password: password.toString(),
          )
              .then((value) {
            Get.offAll(() => const HomeScreen());
          });
        } on FirebaseException catch (e) {}
      }
    } else {
      showToast(
        message: "Enter fields to continue",
        color: Colors.red,
      );
    }
  }
}
