import 'package:chat_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast({
  required String message,
  required Color color,
}) async {
  await Fluttertoast.showToast(
    msg: message,
    backgroundColor: color,
    textColor: AppColor.white,
    gravity: ToastGravity.TOP,
  );
}
