import 'dart:developer';

import 'package:chat_app/controller/log_in_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/authentication/forgot_password_screen.dart';
import 'package:chat_app/screens/authentication/sign_up_screen.dart';
import 'package:chat_app/screens/widgets/close_keyboard.dart';
import 'package:chat_app/screens/widgets/common_elevated_button.dart';
import 'package:chat_app/screens/widgets/common_text_field.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../home/home_screen.dart';
import '../widgets/common_progress_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LogInController loginInController = Get.put(LogInController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    closeKeyboard();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loginInController.clearController();
    closeKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.16,
              ),
              Center(
                child: Text(
                  "Log in",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              CommonTextFiled(
                controller: loginInController.emailController,
                labelText: "Enter email address",
              ),
              SizedBox(
                height: height * 0.04,
              ),
              CommonTextFiled(
                controller: loginInController.passwordController,
                labelText: "Enter password",
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      loginInController.clearController();
                      closeKeyboard();
                      Get.to(
                        () => const ForgotPasswordScreen(),
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        transition: Transition.native,
                      );
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: AppColor.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.08,
              ),
              GetBuilder<LogInController>(
                builder: (controller) {
                  return controller.isLoading
                      ? const CommonCircularProgressIndicator()
                      : CommonElevatedButton(
                          onPressed: () {
                            controller.logIn();
                          },
                          labelText: "Log in",
                          height: height * 0.06,
                        );
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  log(FirebaseFirestore.instance.hashCode.toString());
                  loginInController.clearController();
                  closeKeyboard();
                  Get.to(
                    () => const SignUpScreen(),
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    transition: Transition.native,
                  );
                },
                child: const Text("Don't have an account? SignUp"),
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
