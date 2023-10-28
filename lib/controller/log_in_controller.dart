import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/authentication/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../utils/app_color.dart';
import '../utils/toast.dart';

class LogInController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String photoUrl = '';
  String displayName = '';

  clearController() {
    emailController.clear();
    passwordController.clear();
  }

  logIn() async {
    isLoading = true;
    update();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim().toString(),
        password: passwordController.text.trim().toString(),
      )
          .then((value) async {
        isLoading = false;
        update();
        await GetStorage().write("isLogin", true);
        showToast(
          message: "You are successfully logged in.",
          color: AppColor.green,
        );
        Get.offAll(() => const HomeScreen());
      }).catchError((e) {
        isLoading = false;
        update();
        showToast(
          message: e.toString(),
          color: AppColor.red,
        );
      });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      update();
      showToast(
        message: e.message.toString(),
        color: Colors.red,
      );
    }
  }

  logInValidation() async {
    if (emailController.text.trim().isEmpty) {
      {
        showToast(
          message: "Enter email to continue",
          color: Colors.red,
        );
      }
    } else if (passwordController.text.trim().isEmpty) {
      showToast(
        message: "Enter password to continue",
        color: Colors.red,
      );
    } else {
      logIn();
    }
  }

  currentUserId() {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser!.uid.toString();
    }
    return null;
  }

  User? currentUserData() {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser!;
    }
    return null;
  }

  void currentUserPhotoUrl() async {
    if (currentUserData() != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId())
          .get();

      String str = snapshot.get("profile_picture").toString();
      Get.log("============ $str =====================");

      photoUrl = str;
      update();
    }
  }

  void currentUserName() async {
    if (currentUserData() != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId())
          .get();

      String str = snapshot.get("name").toString();

      displayName = str;
      update();
    } else {}
  }

  void signOut() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await FirebaseAuth.instance.signOut().then((value) async {
          await GetStorage().write("isLogin", false);
          photoUrl = '';
          update();
          displayName = '';
          update();
          Get.offAll(const LoginScreen());
        });
      } on FirebaseException catch (e) {
        showToast(message: e.message.toString(), color: Colors.red);
      }
    }
  }

  void deleteAccount() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserId())
            .delete()
            .then((value) {
          FirebaseFirestore.instance
              .collection("chatRoom")
              .get()
              .then((value) async {
            Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                value.docs.where((element) =>
                    element["participants"]["${currentUserId()}"] == true);
            data.forEach((element) async {
              await FirebaseFirestore.instance
                  .collection("chatRoom")
                  .doc(element.id)
                  .delete()
                  .catchError((e) {
                showToast(message: e.toString(), color: AppColor.red);
              });
            });

            await FirebaseFirestore.instance
                .collection("status")
                .doc(currentUserId().toString())
                .delete();

            await FirebaseAuth.instance.currentUser!
                .delete()
                .then((value) async {
              showToast(
                message: "Your account has been successfully deleted.",
                color: AppColor.green,
              );
              await GetStorage().write("isLogin", false);
              Get.offAll(const LoginScreen());
            }).catchError((e) {
              showToast(message: e.toString(), color: AppColor.red);
            });
          }).catchError((e) {
            showToast(message: e.toString(), color: AppColor.red);
          });
        }).catchError((e) {
          showToast(message: e.toString(), color: AppColor.red);
        });
      } on FirebaseException catch (e) {
        showToast(message: e.message.toString(), color: Colors.red);
      }
    }
  }

  bool isForgotLoading = false;
  forgotPassword({required String email}) async {
    isForgotLoading = true;
    update();
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: email,
      )
          .then((value) {
        isForgotLoading = false;
        update();
        showToast(
          message:
              "password reset email has been sent to your email address successfully.",
          color: AppColor.green,
        );
      });
    } on FirebaseException catch (e) {
      isForgotLoading = false;
      update();
      showToast(message: e.message.toString(), color: AppColor.red);
    }
  }

  checkCurrentUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    currentUserPhotoUrl();
  }
}
