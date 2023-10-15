import 'package:flutter/services.dart';

closeKeyboard() async {
  await SystemChannels.textInput.invokeMethod('TextInput.hide');
}
