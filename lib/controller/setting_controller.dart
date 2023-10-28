import 'dart:developer';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingController extends GetxController {
  privacyPolicy() async {
    try {
      final Uri _url = Uri.parse(
        'https://shreerudrainfotech0.blogspot.com/2023/10/chat-on.html',
      );
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
