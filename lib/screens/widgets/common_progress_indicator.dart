import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class CommonCircularProgressIndicator extends StatelessWidget {
  const CommonCircularProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColor.blue,
      ),
    );
  }
}
