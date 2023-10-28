import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';

import '../../controller/log_in_controller.dart';
import '../widgets/common_progress_indicator.dart';

class StoryViewScreen extends StatefulWidget {
  final String uId;
  const StoryViewScreen({
    super.key,
    required this.uId,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  StoryController storyController = StoryController();
  LogInController logInController = Get.put(LogInController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("status")
              .doc(widget.uId)
              .collection("story")
              .orderBy("date_time")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CommonCircularProgressIndicator();
              } else {
                List response = snapshot.data!.docs;
                return response.isNotEmpty
                    ? Stack(
                        children: [
                          StoryView(
                            storyItems: [
                              for (var i = 0; i < response.length; i++)
                                StoryItem.inlineImage(
                                  url: response[i]["image"].toString(),
                                  controller: storyController,
                                  imageFit: BoxFit.contain,
                                  roundedBottom: true,
                                ),
                            ],
                            onStoryShow: (value) {},
                            onComplete: () {
                              Get.back();
                            },
                            repeat: false,
                            progressPosition: ProgressPosition.top,
                            controller: storyController,
                          ),
                          response.isNotEmpty
                              ? response.first["uId"] ==
                                      logInController.currentUserId()
                                  ? Positioned(
                                      bottom: 0,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          for (var i = 0;
                                              i < response.length;
                                              i++) {
                                            await FirebaseFirestore.instance
                                                .collection("status")
                                                .doc(widget.uId)
                                                .collection("story")
                                                .doc(response[i]["id"]
                                                    .toString())
                                                .delete()
                                                .then((value) {
                                              log("story deleted successfully");
                                              Get.back();
                                            });
                                          }
                                        },
                                        child: Container(
                                          color: Colors.red,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 5,
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 5,
                                          ),
                                          child: const Text("Delete"),
                                        ),
                                      ),
                                    )
                                  : const Text("")
                              : Container(),
                        ],
                      )
                    : const Center(
                        child: Text("Add story"),
                      );
              }
            }
          },
        ),
      ),
    );
  }
}
