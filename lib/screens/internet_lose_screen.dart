import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/internet_controller.dart';
import '../utils/app_color.dart';

class InternetLoseScreen extends StatefulWidget {
  const InternetLoseScreen({super.key});

  @override
  State<InternetLoseScreen> createState() => _InternetLoseScreenState();
}

class _InternetLoseScreenState extends State<InternetLoseScreen> {
  InternetController internetController = Get.put(InternetController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.grey.withOpacity(0.3),
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Check internet connectivity",
                ),
                const SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                  onPressed: () {
                    internetController.connectionRetry();
                  },
                  child: const Text("Retry"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
