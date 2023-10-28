import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/sign_up_controller.dart';
import '../../utils/app_color.dart';
import '../widgets/close_keyboard.dart';
import '../widgets/common_elevated_button.dart';
import '../widgets/common_progress_indicator.dart';
import '../widgets/common_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  void initState() {
    super.initState();
    signUpController.clearController();
    closeKeyboard();
  }

  @override
  void dispose() {
    super.dispose();
    signUpController.clearController();
    closeKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    log("sign up screen build method run");
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.14,
              ),
              Center(
                child: Text(
                  "Create Account",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              CommonTextFiled(
                controller: signUpController.nameController,
                labelText: "Enter name",
              ),
              SizedBox(
                height: height * 0.035,
              ),
              CommonTextFiled(
                controller: signUpController.emailController,
                labelText: "Enter email address",
              ),
              SizedBox(
                height: height * 0.035,
              ),
              GetBuilder<SignUpController>(builder: (logic) {
                return TextField(
                  cursorColor: AppColor.white,
                  controller: logic.passwordController,
                  obscureText: logic.isPasswordVisible ? false : true,
                  decoration: InputDecoration(
                    labelText: "Enter password",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        logic.passwordVisibility();
                      },
                      child: Icon(
                        logic.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColor.grey,
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(
                height: height * 0.1,
              ),
              GetBuilder<SignUpController>(
                builder: (logic) {
                  return logic.isLoading
                      ? const CommonCircularProgressIndicator()
                      : CommonElevatedButton(
                          height: height * 0.06,
                          labelText: "Sign up",
                          onPressed: () {
                            signUpController.signUpValidation();
                          },
                        );
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Already have an account? Login"),
              ),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
