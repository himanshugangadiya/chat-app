import 'package:chat_app/controller/change_password_controller.dart';
import 'package:chat_app/screens/widgets/close_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/common_elevated_button.dart';
import '../widgets/common_progress_indicator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());

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
                  "Change password",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              TextField(
                controller: changePasswordController.newPasswordController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [
                  AutofillHints.email,
                ],
                decoration: const InputDecoration(
                  labelText: "New password",
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              TextField(
                controller: changePasswordController.confirmPasswordController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [
                  AutofillHints.email,
                ],
                decoration: const InputDecoration(
                  labelText: "Confirm new password",
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.08,
              ),
              GetBuilder<ChangePasswordController>(
                builder: (controller) {
                  return controller.isLoading
                      ? const CommonCircularProgressIndicator()
                      : CommonElevatedButton(
                          onPressed: () {
                            closeKeyboard();
                            controller.validate();
                          },
                          labelText: "Save",
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
