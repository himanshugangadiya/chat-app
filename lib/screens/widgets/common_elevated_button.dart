import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String labelText;
  final double height;

  const CommonElevatedButton({
    super.key,
    required this.height,
    required this.onPressed,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: height,
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
