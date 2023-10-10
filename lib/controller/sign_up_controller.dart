import 'package:get/get.dart';

class SignUpController extends GetxController {
  bool isPasswordVisible = false;

  passwordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }
}
