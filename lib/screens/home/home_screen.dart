import 'dart:io';

import 'package:chat_app/screens/home/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/home_controller.dart';
import '../../controller/log_in_controller.dart';
import '../../helper/firebase_helper.dart';
import '../../model/chatroom_model.dart';
import '../../model/user_model.dart';
import '../../utils/app_color.dart';
import '../profile/profile_screen.dart';
import '../widgets/close_keyboard.dart';
import '../widgets/common_cache_network_image.dart';
import '../widgets/common_progress_indicator.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeController homeController = Get.put(HomeController());
  LogInController logInController = Get.put(LogInController());

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
    return WillPopScope(
      onWillPop: () async {
        return exitDialog(context: context);
      },
      child: SafeArea(
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
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                                                                    userModel
                                                                        .name
                                                                        .toString(),
                                                                targetUserPhotoUrl:
                                                                    userModel
                                                                        .profilePicture
                                                                        .toString(),
                                                              ),
                                                              duration:
                                                                  const Duration(
                                                                milliseconds:
                                                                    500,
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
                                                                      radius:
                                                                          28,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blue,
                                                                      child: userModel.profilePicture !=
                                                                              ''
                                                                          ? CommonCacheNetworkImage(
                                                                              imageUrl: userModel.profilePicture.toString(),
                                                                            )
                                                                          : Text(
                                                                              userModel.name![0].toUpperCase().toString(),
                                                                              style: const TextStyle(
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
                                                                    child:
                                                                        Column(
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
                                                                              child: Text(
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
                                                                          height:
                                                                              height * 0.002,
                                                                          width:
                                                                              double.infinity,
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
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        return Center(
                                                                          child:
                                                                              Text(
                                                                            snapshot.error.toString(),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        if (snapshot
                                                                            .hasData) {
                                                                          var res = snapshot
                                                                              .data!
                                                                              .docs;
                                                                          List unseenData = res
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
                                                                              date.day == DateTime.now().day && date.month == DateTime.now().month
                                                                                  ? Text(
                                                                                      DateFormat("hh:mm a").format(date).toString(),
                                                                                      style: TextStyle(
                                                                                        color: unseenData.isEmpty ? AppColor.grey : AppColor.blue,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                    )
                                                                                  : Text(
                                                                                      DateFormat("dd/MM/yy").format(date).toString(),
                                                                                      style: TextStyle(
                                                                                        color: unseenData.isEmpty ? AppColor.grey : AppColor.blue,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                    ),
                                                                              SizedBox(
                                                                                height: height * 0.002,
                                                                              ),
                                                                              CircleAvatar(
                                                                                radius: 10,
                                                                                backgroundColor: unseenData.length != 0 ? AppColor.blue : Colors.transparent,
                                                                                child: FittedBox(
                                                                                  child: Text(
                                                                                    unseenData.length.toString(),
                                                                                    style: TextStyle(
                                                                                      color: unseenData.length != 0 ? AppColor.white : Colors.transparent,
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
                                                        child: Text(snapshot
                                                            .error
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
      ),
    );
  }

  Future<bool> exitDialog({
    required BuildContext context,
  }) async {
    return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to exit?",
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  color: AppColor.grey,
                  child: const Text("No"),
                ),
                MaterialButton(
                  onPressed: () {
                    exit(0);
                  },
                  color: AppColor.blue,
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;
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
                "Chat ON",
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
        title: GestureDetector(
          onTap: () async {
            homeController.deleteChat(chatRoomModel: chatRoomModel);
          },
          child: Center(
            child: Text(
              "Delete chat permanent?",
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
        content: const Text(
          "If you delete the chat, the chat will be deleted from both sides(sender and receiver)",
        ),
      );
    }),
  );
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
