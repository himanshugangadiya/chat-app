import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_color.dart';
import '../utils/toast.dart';

class ChangePasswordController extends GetxController {
  bool isLoading = false;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  clearData() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    isLoading = false;
  }

  validate() {
    if (newPasswordController.text.isEmpty) {
      showToast(message: "Enter new password", color: AppColor.red);
    } else if (confirmPasswordController.text.isEmpty) {
      showToast(message: "Enter confirm password", color: AppColor.red);
    } else if (newPasswordController.text != confirmPasswordController.text) {
      showToast(
        message: "New password and confirm password are not same.",
        color: AppColor.red,
      );
    } else {
      changePassword(newPassword: newPasswordController.text.trim());
    }
  }

  changePassword({required String newPassword}) async {
    isLoading = true;
    update();
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(newPassword)
            .then((value) {
          isLoading = false;
          update();
          showToast(
            message: "Your password has been changed successfully.",
            color: AppColor.green,
          );
          clearData();
          Get.back();
        });
      }
    } on FirebaseException catch (e) {
      isLoading = false;
      update();
      showToast(message: e.message.toString(), color: AppColor.red);
      Get.log(e.message.toString());
      clearData();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    clearData();
  }
}
