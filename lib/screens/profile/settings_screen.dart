import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/log_in_controller.dart';
import '../../controller/setting_controller.dart';
import '../../utils/app_color.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingController settingController = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    LogInController logInController = Get.put(LogInController());
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.03,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Settings",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                letterSpacing: 1.2,
                              ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.04,
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(
                        () => const ChangePasswordScreen(),
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        transition: Transition.native,
                      );
                    },
                    leading: const Icon(Icons.lock),
                    title: const Text("Change password"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 17,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      deleteAccountDialog(
                        context: context,
                        logInController: logInController,
                      );
                    },
                    leading: const Icon(Icons.person_off),
                    title: const Text("Delete account"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 17,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      logInController.signOut();
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text("Log out"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 17,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "version 1.0.0",
                    style: TextStyle(
                      color: AppColor.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

deleteAccountDialog({
  required BuildContext context,
  required LogInController logInController,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are your sure you want to delete this account permanently?",
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Get.back();
            },
            color: AppColor.grey,
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              logInController.deleteAccount();
            },
            color: AppColor.blue,
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}
