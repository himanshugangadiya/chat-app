import 'package:chat_app/controller/change_password_controller.dart';
import 'package:chat_app/controller/log_in_controller.dart';
import 'package:chat_app/screens/widgets/close_keyboard.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/common_elevated_button.dart';
import '../widgets/common_progress_indicator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
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
    emailController.clear();
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
                  "Forgot password",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              TextField(
                controller: emailController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [
                  AutofillHints.email,
                ],
                decoration: const InputDecoration(
                  labelText: "Enter email",
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              const Text(
                "if your email address is exist  password reset email will sent to your email address.",
                style: TextStyle(
                  color: AppColor.grey,
                ),
              ),
              SizedBox(
                height: height * 0.15,
              ),
              GetBuilder<LogInController>(
                builder: (controller) {
                  return controller.isForgotLoading
                      ? const CommonCircularProgressIndicator()
                      : CommonElevatedButton(
                          onPressed: () {
                            closeKeyboard();
                            controller.forgotPassword(
                              email: emailController.text.trim().toString(),
                            );
                          },
                          labelText: "Send",
                          height: height * 0.06,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
