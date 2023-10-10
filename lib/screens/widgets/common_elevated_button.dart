import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String labelText;
  const CommonElevatedButton({
    super.key,
    required this.height,
    required this.onPressed,
    required this.labelText,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: height * 0.06,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(labelText.toString()),
            ),
          ),
        ),
      ],
    );
  }
}
