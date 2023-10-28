import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_color.dart';

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
