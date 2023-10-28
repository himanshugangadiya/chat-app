import 'package:chat_app/screens/profile/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../controller/log_in_controller.dart';
import '../../controller/profile_controller.dart';
import '../../utils/app_color.dart';
import '../widgets/common_cache_network_image.dart';
import '../widgets/common_elevated_button.dart';
import '../widgets/common_progress_indicator.dart';
import '../widgets/common_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HomeController homeController = Get.put(HomeController());
  LogInController loginController = Get.put(LogInController());
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Material(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              /// header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.025,
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: CircleAvatar(
                        backgroundColor: AppColor.blue,
                        radius: 19,
                        child: loginController.photoUrl != ""
                            ? CommonCacheNetworkImage(
                                imageUrl: loginController.photoUrl.toString(),
                              )
                            : loginController.displayName != ''
                                ? Text(
                                    loginController.displayName[0]
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColor.white,
                                    ),
                                  )
                                : Container(),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Expanded(
                      child: Text(
                        "Profile",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  letterSpacing: 1.2,
                                ),
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(
                          () => const SettingsScreen(),
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                          transition: Transition.native,
                        );
                      },
                      icon: const Icon(
                        Icons.settings,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: height * 0.01,
              ),

              /// profile picture
              Hero(
                tag: "profile",
                child:
                    GetBuilder<ProfileController>(builder: (profileController) {
                  return Stack(
                    children: [
                      ClipOval(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.blue,
                          child: profileController.isImageSelected == false &&
                                  loginController.photoUrl != ''
                              ? CommonCacheNetworkImage(
                                  imageUrl: loginController.photoUrl.toString(),
                                )
                              : profileController.image != null
                                  ? Image.file(
                                      profileController.image!,
                                      fit: BoxFit.contain,
                                    )
                                  : loginController.displayName != ''
                                      ? Text(
                                          loginController.displayName[0]
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColor.white,
                                            fontSize: 28,
                                          ),
                                        )
                                      : Container(),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 8,
                        top: 94,
                        child: GestureDetector(
                          onTap: () {
                            profileController.cameraPermission();
                          },
                          child: const CircleAvatar(
                            radius: 14,
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.blueAccent,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Icon(
                                  Icons.photo_camera_back,
                                  color: AppColor.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),

              SizedBox(
                height: height * 0.03,
              ),

              /// name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      color: AppColor.blue,
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Expanded(
                      child: CommonTextFiled(
                        controller: profileController.nameController,
                        labelText: "Name",
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: height * 0.03,
              ),

              /// email
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      color: AppColor.blue,
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Expanded(
                      child: CommonTextFiled(
                        isEnabled: false,
                        controller: profileController.emailController,
                        labelText: "Email",
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// button
              GetBuilder<ProfileController>(
                init: profileController,
                builder: (profileController) {
                  return profileController.isLoading
                      ? const CommonCircularProgressIndicator()
                      : Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: CommonElevatedButton(
                            height: height * 0.06,
                            onPressed: () async {
                              profileController.updateImageProfile(
                                name: profileController.nameController.text
                                    .trim()
                                    .toString(),
                              );
                            },
                            labelText: "Save",
                          ),
                        );
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
