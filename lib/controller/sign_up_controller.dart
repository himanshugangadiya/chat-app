import 'package:chat_app/screens/home/home_screen.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:chat_app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class SignUpController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  passwordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  clearController() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
  }

  signUp() async {
    isLoading = true;
    update();
    if (nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      UserCredential? userCredential;
      try {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim().toString(),
          password: passwordController.text.trim().toString(),
        );

        if (userCredential.user != null) {
          await userCredential.user!
              .updateDisplayName(nameController.text.trim().toString());
          String uId = userCredential.user!.uid;

          try {
            await FirebaseFirestore.instance.collection("users").doc(uId).set(
              {
                "name": nameController.text.trim(),
                "email": emailController.text.trim(),
                "uId": uId,
                "profile_picture": "",
              },
            ).then((value) {
              clearController();
              isLoading = false;
              update();
              showToast(
                message: "Account create has been successfully.",
                color: AppColor.green,
              );
              Get.offAll(() => const HomeScreen());
            }).catchError((e) {
              showToast(message: e.toString(), color: AppColor.red);
            });
          } on FirebaseException catch (e) {
            isLoading = false;
            update();
            showToast(message: e.message.toString(), color: AppColor.red);
          }
        } else {
          showToast(message: "Email not verified", color: Colors.yellow);
        }
      } on FirebaseException catch (e) {
        isLoading = false;
        update();
        showToast(message: e.message.toString(), color: AppColor.red);
      }
    } else {
      isLoading = false;
      update();
      showToast(message: "Enter fields to continue", color: AppColor.red);
    }
  }
}
