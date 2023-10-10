import 'package:chat_app/controller/log_in_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/authentication/sign_up_screen.dart';
import 'package:chat_app/screens/widgets/common_elevated_button.dart';
import 'package:chat_app/screens/widgets/common_text_field.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                controller: emailController,
                labelText: "Enter email address",
              ),
              SizedBox(
                height: height * 0.04,
              ),
              CommonTextFiled(
                controller: passwordController,
                labelText: "Enter password",
              ),
              SizedBox(
                height: height * 0.02,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: AppColor.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.08,
              ),
              GetBuilder(
                  init: Get.find<LoginInController>(),
                  builder: (controller) {
                    return CommonElevatedButton(
                      onPressed: () {
                        controller.logIn(
                          email: emailController.text.trim().toString(),
                          password: passwordController.text.trim().toString(),
                        );
                      },
                      labelText: "Log in",
                      height: height,
                    );
                  }),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.to(() => const SignUpScreen());
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
