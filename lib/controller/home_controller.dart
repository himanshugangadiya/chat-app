import 'dart:developer';
import 'dart:io';

import 'package:chat_app/model/chatroom_model.dart';
import 'package:chat_app/screens/widgets/common_progress_indicator.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:chat_app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
      print(currentUserModel!.name);
      print(currentUserModel!.email);
      print(currentUserModel!.uId);
      print(currentUserModel!.profilePicture);
    }
  }

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

  /// step-1
  pickImageFromGallery() async {
    XFile? pickFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickFile != null) {
      isImageSelected = true;
      update();
      showImageDialog(pickFile);
      // cropImage(File(pickFile.path));
    } else {
      print("null ");
    }
  }

  /// step-2
  showImageDialog(XFile pickFile) {
    if (isImageSelected) {
      Get.dialog(
        Material(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColor.white.withOpacity(0.3),
            child: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  child: Image.file(
                    File(pickFile.path),
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 2,
                  right: 5,
                  child: GetBuilder<HomeController>(builder: (logic) {
                    return logic.isLoading
                        ? const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Wait...."),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  fileToStringConvert(File(pickFile.path));
                                },
                                icon: const Icon(
                                  Icons.telegram,
                                  size: 40,
                                ),
                              ),
                            ],
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  bool isLoading = false;

  /// step-3
  fileToStringConvert(File file) async {
    isLoading = true;
    update();
    try {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('status/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      if (downloadUrl != '') {
        addStory(image: downloadUrl.toString());
      }
    } on FirebaseException catch (e) {
      isLoading = false;
      update();
      showToast(message: e.message.toString(), color: AppColor.red);
    }
  }

  /// step-4
  addStory({required String image}) async {
    var uuid = const Uuid().v1();
    isLoading = true;
    update();
    try {
      await FirebaseFirestore.instance
          .collection("status")
          .doc(loginInController.currentUserId())
          .set({
        "name": loginInController.displayName.toString(),
        "profile_picture": loginInController.photoUrl.toString(),
      }).then((value) async {
        log("name and profile updated");
        await FirebaseFirestore.instance
            .collection("status")
            .doc(loginInController.currentUserId())
            .collection("story")
            .doc(uuid.toString())
            .set({
          "id": uuid,
          "image": image.toString(),
          "uId": loginInController.currentUserId().toString(),
          "date_time": Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch,
          ),
        }).then((value) {
          isLoading = false;
          isImageSelected = false;
          update();
          log("story added successfully.");
          Get.back();
        });
      });
    } on FirebaseException catch (e) {
      isLoading = false;
      update();
      showToast(message: e.message.toString(), color: AppColor.red);
    }
  }
}
