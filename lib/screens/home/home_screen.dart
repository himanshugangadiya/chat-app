import 'dart:developer';
import 'dart:math';

import 'package:animated_dashed_circle/animated_dashed_circle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/controller/home_controller.dart';
import 'package:chat_app/controller/log_in_controller.dart';
import 'package:chat_app/helper/firebase_helper.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chatroom_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:chat_app/screens/home/search_screen.dart';
import 'package:chat_app/screens/home/story_view_screen.dart';
import 'package:chat_app/screens/profile/profile_screen.dart';
import 'package:chat_app/screens/widgets/close_keyboard.dart';
import 'package:chat_app/screens/widgets/common_progress_indicator.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/common_cache_network_image.dart';

List<String> storyList = [
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxbxmRFn4kylMSoauNgEEetqaWpvVLFgvd9U50qbFQD234iyJbxuGY06Xw9GH_Cn7k4n8&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxbxmRFn4kylMSoauNgEEetqaWpvVLFgvd9U50qbFQD234iyJbxuGY06Xw9GH_Cn7k4n8&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxbxmRFn4kylMSoauNgEEetqaWpvVLFgvd9U50qbFQD234iyJbxuGY06Xw9GH_Cn7k4n8&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxbxmRFn4kylMSoauNgEEetqaWpvVLFgvd9U50qbFQD234iyJbxuGY06Xw9GH_Cn7k4n8&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxbxmRFn4kylMSoauNgEEetqaWpvVLFgvd9U50qbFQD234iyJbxuGY06Xw9GH_Cn7k4n8&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxbxmRFn4kylMSoauNgEEetqaWpvVLFgvd9U50qbFQD234iyJbxuGY06Xw9GH_Cn7k4n8&usqp=CAU",
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  LogInController logInController = Get.put(LogInController());

  List<dynamic> status = [
    storyList,
    storyList,
    storyList,
    storyList,
    storyList,
  ];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    closeKeyboard();
    homeController.currentUserInfo();
    logInController.currentUserPhotoUrl();
    logInController.currentUserName();
    Future.delayed(
      const Duration(milliseconds: 1200),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Material(
        child: Scaffold(
          body: isLoading
              ? const CommonCircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// header
                    CommonHeaderWidget(
                      height: height,
                      width: width,
                    ),

                    /// search
                    SearchTextFieldWidget(
                      width: width,
                      homeController: homeController,
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),

                    /// status
                    StatusTextWidget(width: width),

                    SizedBox(
                      height: height * 0.01,
                    ),

                    /// status list
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("status")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CommonCircularProgressIndicator();
                          } else {
                            List response = snapshot.data!.docs;
                            List data = response
                                .where((element) =>
                                    element.id !=
                                    logInController.currentUserId())
                                .toList();
                            var currentUserData = response.where((element) =>
                                element.id == logInController.currentUserId());

                            return response.isNotEmpty
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      height: height * 0.11,
                                      child: Row(
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.cover,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 18,
                                              ),
                                              child: GestureDetector(
                                                onLongPress: () {
                                                  // homeController.addStory();
                                                  currentUserData.isNotEmpty
                                                      ? Get.to(
                                                          () => StoryViewScreen(
                                                            uId: logInController
                                                                .currentUserId(),
                                                          ),
                                                        )
                                                      : Container();
                                                },
                                                onTap: () {
                                                  homeController
                                                      .pickImageFromGallery();
                                                },
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        logInController
                                                                    .photoUrl ==
                                                                ''
                                                            ? CircleAvatar(
                                                                radius: 29,
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      AppColor
                                                                          .blue,
                                                                  radius: 28,
                                                                  child: Text(
                                                                    logInController.displayName !=
                                                                            ''
                                                                        ? logInController.displayName[
                                                                            0]
                                                                        : ""
                                                                            .toUpperCase()
                                                                            .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: AppColor
                                                                          .white,
                                                                      fontSize:
                                                                          19,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : AnimatedDashedCircle()
                                                                .show(
                                                                image:
                                                                    NetworkImage(
                                                                  logInController
                                                                      .photoUrl
                                                                      .toString(),
                                                                ),
                                                                autoPlay: true,
                                                                contentPadding:
                                                                    1,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            0),
                                                                height: 59,
                                                                contentColor:
                                                                    AppColor
                                                                        .black,
                                                                borderWidth: 2,
                                                                imageBgColor:
                                                                    AppColor
                                                                        .black,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 1,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              homeController
                                                                  .pickImageFromGallery();
                                                            },
                                                            child:
                                                                const CircleAvatar(
                                                              radius: 8,
                                                              backgroundColor:
                                                                  Colors
                                                                      .greenAccent,
                                                              child: FittedBox(
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: AppColor
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.01,
                                                    ),
                                                    Text(
                                                      "Stories",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          ListView.builder(
                                            itemCount: data.length,
                                            padding: EdgeInsets.only(
                                              left: width * 0.05,
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return FittedBox(
                                                fit: BoxFit.cover,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 3,
                                                    bottom: 3,
                                                    right: 8,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                        () => StoryViewScreen(
                                                          uId: data[index]
                                                              .id
                                                              .toString(),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      children: [
                                                        AnimatedDashedCircle()
                                                            .show(
                                                          image: data[index][
                                                                      "profile_picture"] !=
                                                                  ''
                                                              ? NetworkImage(data[
                                                                          index]
                                                                      [
                                                                      "profile_picture"]
                                                                  .toString())
                                                              : const NetworkImage(
                                                                  "https://ent-md.com/wp-content/uploads/2019/07/dummy-profile-pic-300x300.png"),
                                                          autoPlay: true,
                                                          contentPadding: 1,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 0),
                                                          height: 35,
                                                          contentColor:
                                                              AppColor.black,
                                                          borderWidth: 2,
                                                          imageBgColor:
                                                              AppColor.black,
                                                          color:
                                                              Colors.blueAccent,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.005,
                                                        ),
                                                        Text(
                                                          data[index]["name"]
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          8),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 18,
                                      ),
                                      child: GestureDetector(
                                        onLongPress: () {
                                          // homeController.addStory();
                                          currentUserData.isNotEmpty
                                              ? Get.to(
                                                  () => StoryViewScreen(
                                                    uId: logInController
                                                        .currentUserId(),
                                                  ),
                                                )
                                              : Container();
                                        },
                                        onTap: () {
                                          homeController.pickImageFromGallery();
                                        },
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                logInController.photoUrl != ''
                                                    ? AnimatedDashedCircle()
                                                        .show(
                                                        image: NetworkImage(
                                                          logInController
                                                              .photoUrl
                                                              .toString(),
                                                        ),
                                                        autoPlay: true,
                                                        contentPadding: 1,
                                                        duration:
                                                            const Duration(
                                                                seconds: 0),
                                                        height: 59,
                                                        contentColor:
                                                            AppColor.black,
                                                        borderWidth: 2,
                                                        imageBgColor:
                                                            AppColor.black,
                                                        color: Colors.blue,
                                                      )
                                                    : CircleAvatar(
                                                        radius: 29,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              AppColor.blue,
                                                          radius: 28,
                                                          child: Text(
                                                            logInController
                                                                        .displayName !=
                                                                    ''
                                                                ? logInController
                                                                        .displayName[
                                                                    0]
                                                                : ""
                                                                    .toUpperCase()
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color: AppColor
                                                                  .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 1,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      homeController
                                                          .pickImageFromGallery();
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          Colors.greenAccent,
                                                      child: FittedBox(
                                                        child: Icon(
                                                          Icons.add,
                                                          color: AppColor.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Text(
                                              "Stories",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          }
                        }
                      },
                    ),

                    Divider(
                      height: height * 0.04,
                      indent: 18,
                    ),

                    FriendsTextWidget(width: width, height: height),

                    SizedBox(
                      height: height * 0.01,
                    ),

                    /// chat list
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chatRoom")
                          .where(
                            "users",
                            arrayContains: logInController.currentUserId(),
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CommonCircularProgressIndicator();
                          } else {
                            List res = snapshot.data!.docs.reversed.toList();
                            return res.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: res.length,
                                      physics: const BouncingScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                      ),
                                      itemBuilder: (context, index) {
                                        var data = res[index].data();
                                        ChatRoomModel chatRoomModel =
                                            ChatRoomModel.fromMap(
                                                data as Map<String, dynamic>);

                                        Map participantsMap =
                                            chatRoomModel.participants;
                                        List participantsList =
                                            participantsMap.keys.toList();
                                        participantsList.remove(
                                            logInController.currentUserId());
                                        return data.isNotEmpty

                                            /// return widget
                                            ? FutureBuilder(
                                                future: FirebaseHelper()
                                                    .getUserById(
                                                        participantsList[0]),
                                                builder: (context, snapshot) {
                                                  var date = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                    chatRoomModel
                                                        .lastMessageTime!
                                                        .millisecondsSinceEpoch,
                                                  );
                                                  if (snapshot.hasData) {
                                                    UserModel userModel =
                                                        snapshot.data
                                                            as UserModel;

                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical:
                                                            height * 0.008,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                            ChatScreen(
                                                              chatRoomModel:
                                                                  chatRoomModel,
                                                              targetUserName:
                                                                  userModel.name
                                                                      .toString(),
                                                              targetUserPhotoUrl:
                                                                  userModel
                                                                      .profilePicture
                                                                      .toString(),
                                                            ),
                                                            duration:
                                                                const Duration(
                                                              milliseconds: 500,
                                                            ),
                                                            transition:
                                                                Transition
                                                                    .native,
                                                          );
                                                        },
                                                        onLongPress: () {
                                                          deleteChatDialog(
                                                            context: context,
                                                            chatRoomModel:
                                                                chatRoomModel,
                                                            homeController:
                                                                homeController,
                                                          );
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                ClipOval(
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 28,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                    child: userModel.profilePicture !=
                                                                            ''
                                                                        ? CommonCacheNetworkImage(
                                                                            imageUrl:
                                                                                userModel.profilePicture.toString(),
                                                                          )
                                                                        : Text(
                                                                            userModel.name![0].toUpperCase().toString(),
                                                                            style:
                                                                                const TextStyle(
                                                                              color: AppColor.white,
                                                                              fontSize: 19,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.025,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              "${userModel.name.toString()[0].toUpperCase()}${userModel.name.toString().substring(1).toString()}",
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: height *
                                                                            0.002,
                                                                        width: double
                                                                            .infinity,
                                                                      ),
                                                                      chatRoomModel.lastMessage !=
                                                                              ''
                                                                          ? Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    chatRoomModel.lastMessage.toString(),
                                                                                    style: const TextStyle(
                                                                                      color: AppColor.grey,
                                                                                    ),
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : const Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    "Say! hi to your frd",
                                                                                    style: TextStyle(
                                                                                      color: Colors.blue,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                StreamBuilder(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "chatRoom")
                                                                      .doc(chatRoomModel
                                                                          .id)
                                                                      .collection(
                                                                          "message")
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      return Center(
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .error
                                                                              .toString(),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        var res = snapshot
                                                                            .data!
                                                                            .docs;
                                                                        List data = res
                                                                            .where((element) => element["sender"].toString() != logInController.currentUserId())
                                                                            .where(
                                                                              (element) => element["isSeen"] == false,
                                                                            )
                                                                            .toList();

                                                                        return Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              DateFormat("hh:mm a").format(date).toString(),
                                                                              style: TextStyle(
                                                                                color: data.isEmpty ? AppColor.grey : AppColor.blue,
                                                                              ),
                                                                              maxLines: 1,
                                                                            ),
                                                                            SizedBox(
                                                                              height: height * 0.002,
                                                                            ),
                                                                            CircleAvatar(
                                                                              radius: 10,
                                                                              backgroundColor: data.length != 0 ? AppColor.blue : Colors.transparent,
                                                                              child: FittedBox(
                                                                                child: Text(
                                                                                  data.length.toString(),
                                                                                  style: TextStyle(
                                                                                    color: data.length != 0 ? AppColor.white : Colors.transparent,
                                                                                  ),
                                                                                  maxLines: 1,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      } else {
                                                                        return Container();
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            const Divider(
                                                              indent: 67,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Center(
                                                      child: Text(snapshot.error
                                                          .toString()),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              )
                                            : Container();
                                      },
                                    ),
                                  )
                                : const Expanded(
                                    child: Center(
                                      child: Text("No messages"),
                                    ),
                                  );
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CircleSkeletonWidget extends StatelessWidget {
  const CircleSkeletonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleSkeleton(
            radius: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RectangleSkeleton(
                height: 12,
                width: 80,
              ),
              SizedBox(
                height: 8,
              ),
              RectangleSkeleton(
                height: 12,
                width: 120,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class RectangleSkeleton extends StatelessWidget {
  final double height;
  final double width;
  const RectangleSkeleton(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: height,
        width: width,
        color: AppColor.white.withOpacity(0.15),
      ),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  final double radius;
  const CircleSkeleton({
    super.key,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColor.white.withOpacity(0.15),
    );
  }
}

class CommonHeaderWidget extends StatelessWidget {
  final double height;
  final double width;

  const CommonHeaderWidget({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.025,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => const ProfileScreen());
            },
            child: Hero(
              tag: "profile",
              child: GetBuilder<LogInController>(builder: (logic) {
                return ClipOval(
                  child: CircleAvatar(
                    backgroundColor: AppColor.blue,
                    radius: 19,
                    child: logic.photoUrl == ''
                        ? logic.displayName != ''
                            ? Text(
                                logic.displayName[0].toString().toUpperCase(),
                                style: const TextStyle(
                                  color: AppColor.white,
                                ),
                              )
                            : Container()
                        : CommonCacheNetworkImage(
                            imageUrl: logic.photoUrl.toString(),
                          ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          Expanded(
            child: GetBuilder<LogInController>(builder: (logic) {
              return Text(
                logic.currentUserData() != null
                    ? logic.displayName.toString()
                    : "",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      letterSpacing: 1.2,
                    ),
                maxLines: 1,
              );
            }),
          ),
        ],
      ),
    );
  }
}

deleteChatDialog({
  required BuildContext context,
  required ChatRoomModel chatRoomModel,
  required HomeController homeController,
}) {
  return showDialog(
    context: context,
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                homeController.deleteChat(chatRoomModel: chatRoomModel);
              },
              child: const Text(
                "Delete chat permanent?",
              ),
            ),
          ],
        ),
      );
    }),
  );
}

class FriendsTextWidget extends StatelessWidget {
  const FriendsTextWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.01,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: height * 0.04,
              width: width * 0.25,
              color: AppColor.blue,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: const Text("Friends"),
            ),
          ),
          SizedBox(
            width: width * 0.02,
          ),
        ],
      ),
    );
  }
}

class StatusTextWidget extends StatelessWidget {
  const StatusTextWidget({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
      ),
      child: Text(
        "Status",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class SearchTextFieldWidget extends StatelessWidget {
  const SearchTextFieldWidget({
    super.key,
    required this.width,
    required this.homeController,
  });

  final double width;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(
            SearchScreen(userModel: homeController.currentUserModel),
          );
        },
        child: TextField(
          enabled: false,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: "Search...",
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.white.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
