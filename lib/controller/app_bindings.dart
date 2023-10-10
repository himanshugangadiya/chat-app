import 'package:chat_app/controller/log_in_controller.dart';
import 'package:chat_app/controller/sign_up_controller.dart';
import 'package:get/get.dart';

class AllBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => LoginInController());
  }
}
