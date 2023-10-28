import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/chatroom_model.dart';
import '../model/user_model.dart';

import 'log_in_controller.dart';

class HomeController extends GetxController {
  LogInController loginInController = Get.put(LogInController());
  UserModel? currentUserModel;
  bool isImageSelected = false;

  /// current user get
  currentUserInfo() async {
    if (loginInController.currentUserId() != '') {
      DocumentSnapshot response = await FirebaseFirestore.instance
          .collection("users")
          .doc(loginInController.currentUserId())
          .get();
      currentUserModel =
          UserModel.fromMap(response.data() as Map<String, dynamic>);
      log(currentUserModel!.name.toString());
      log(currentUserModel!.email.toString());
      log(currentUserModel!.uId.toString());
      log(currentUserModel!.profilePicture.toString());
    }
  }

  /// delete chat
  deleteChat({
    required ChatRoomModel chatRoomModel,
  }) async {
    Get.log(chatRoomModel.id.toString());
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomModel.id)
        .delete()
        .then((value) {
      Get.log("chatroom deleted");
      Get.back();
    });
  }
}
