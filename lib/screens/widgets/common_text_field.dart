import 'package:flutter/material.dart';

class CommonTextFiled extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  bool isEnabled;

  CommonTextFiled({
    super.key,
    required this.controller,
    required this.labelText,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText.toString(),
      ),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),

    );
  }
}
