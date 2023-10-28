import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/home/home_screen.dart';
import '../utils/app_color.dart';
import '../utils/toast.dart';
import 'log_in_controller.dart';

class ProfileController extends GetxController {
  LogInController logInController = Get.put(LogInController());

  late TextEditingController nameController;
  late TextEditingController emailController;
  ImagePicker imagePicker = ImagePicker();
  final _firebaseStorage = FirebaseStorage.instance;
  File? image;
  bool isImageSelected = false;
  bool isLoading = false;
  String profileImage = '';

  /// pick image
  cameraPermission() async {
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus.isDenied) {
      await Permission.camera.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else if (permissionStatus.isGranted) {
      pickImageFromGallery();
    }
  }

  pickImageFromGallery() async {
    XFile? pickFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickFile != null) {
      isImageSelected = true;
      update();
      cropImage(File(pickFile.path));
    } else {
      log("null ");
    }
  }

  cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColor.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      imageCache.clear();

      image = File(croppedFile.path);
      update();
    }
  }

  imageFileToStringConvert() async {
    if (image != null) {
      isLoading = true;
      update();
      try {
        var snapshot = await _firebaseStorage
            .ref()
            .child('profileImages/${DateTime.now().millisecondsSinceEpoch}')
            .putFile(image!);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        if (downloadUrl != '' &&
            logInController.currentUserId() != '' &&
            logInController.currentUserId() != null) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(logInController.currentUserId().toString())
              .update({"profile_picture": downloadUrl.toString()}).then(
                  (value) async {
            await FirebaseAuth.instance.currentUser!
                .updatePhotoURL(downloadUrl.toString())
                .then((value) {
              isLoading = false;
              update();
              Get.log("Update image url in both");
              Get.offAll(() => const HomeScreen());
            });
          });
        } else {
          isLoading = false;
          update();
          Get.offAll(() => const HomeScreen());
          Get.log("download url is empty");
        }
      } on FirebaseException catch (e) {
        isLoading = false;
        update();
        showToast(message: e.message.toString(), color: AppColor.red);
      }
    } else {
      isLoading = false;
      update();
      Get.offAll(() => const HomeScreen());
      Get.log("No image select from gallery");
    }
  }

  /// name and email update
  nameUpdate({
    required String name,
  }) async {
    if (name.isNotEmpty) {
      isLoading = true;
      update();
      try {
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.currentUser!
              .updateDisplayName(name.toString())
              .then((value) async {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(logInController.currentUserId().toString())
                .update({
              "name": name,
            }).then((value) {
              Get.log("name updated ======================== ");
              imageFileToStringConvert();
            });
          });
        }
      } on FirebaseException catch (e) {
        isLoading = false;
        update();
        showToast(message: e.message.toString(), color: AppColor.grey);
      }
    }
  }

  updateImageProfile({
    required String name,
  }) {
    try {
      nameUpdate(name: name);
    } on Exception catch (e) {
      showToast(
        message: e.toString(),
        color: AppColor.red,
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nameController = TextEditingController(
        text: logInController.currentUserData() != null
            ? logInController.displayName.toString()
            : '');
    emailController = TextEditingController(
        text: logInController.currentUserData() != null
            ? logInController.currentUserData()!.email.toString()
            : '');
  }
}
