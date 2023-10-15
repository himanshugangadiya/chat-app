import 'dart:developer';

import 'package:chat_app/controller/sign_up_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/authentication/login_screen.dart';
import 'package:chat_app/screens/widgets/close_keyboard.dart';
import 'package:chat_app/screens/widgets/common_progress_indicator.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../home/home_screen.dart';
import '../widgets/common_elevated_button.dart';
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
    double width = MediaQuery.sizeOf(context).width;
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
                            signUpController.signUp();
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
