import 'package:flutter/material.dart';

class CommonTextFiled extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CommonTextFiled({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText.toString(),
      ),
    );
  }
}
