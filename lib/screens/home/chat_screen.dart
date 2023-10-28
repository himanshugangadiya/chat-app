import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../model/chatroom_model.dart';
import '../../utils/app_color.dart';
import '../widgets/common_cache_network_image.dart';
import '../widgets/common_progress_indicator.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoomModel chatRoomModel;
  final String targetUserName;
  final String targetUserPhotoUrl;
  const ChatScreen({
    super.key,
    required this.chatRoomModel,
    required this.targetUserName,
    required this.targetUserPhotoUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  var uuid = const Uuid();

  sendMessage() {
    String newMsgId = uuid.v1();
    if (messageController.text.trim().isNotEmpty &&
        messageController.text.trim() != '') {
      try {
        FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(widget.chatRoomModel.id.toString())
            .collection("message")
            .doc(newMsgId)
            .set({
          "time": Timestamp.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
          "message": messageController.text.trim().toString(),
          "messageId": newMsgId,
          "sender": FirebaseAuth.instance.currentUser!.uid.toString(),
          "isSeen": false,
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("chatRoom")
              .doc(widget.chatRoomModel.id)
              .update({
            "last_message": messageController.text.trim().toString(),
            "last_message_time": Timestamp.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch),
          });
          messageController.clear();
        });
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }
    }
  }

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
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 18,
                  ),
                ),
                ClipOval(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: widget.targetUserPhotoUrl != null &&
                            widget.targetUserPhotoUrl != ""
                        ? CommonCacheNetworkImage(
                            imageUrl: widget.targetUserPhotoUrl.toString(),
                          )
                        : Text(
                            widget.targetUserName[0].toUpperCase().toString(),
                            style: const TextStyle(
                              color: AppColor.white,
                              fontSize: 19,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Expanded(
                  child: Text(
                    widget.targetUserName.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            widget.chatRoomModel.id != '' && widget.chatRoomModel.id != null
                ? Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chatRoom")
                          .doc(widget.chatRoomModel.id.toString())
                          .collection("message")
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else {
                          if (snapshot.hasData) {
                            var res = snapshot.data!.docs;

                            return res.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    reverse: true,
                                    itemCount: res.length,
                                    itemBuilder: (context, index) {
                                      var data = res[index].data();
                                      if (data["isSeen"] == false) {
                                        if (data["sender"] !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                          FirebaseFirestore.instance
                                              .collection("chatRoom")
                                              .doc(widget.chatRoomModel.id)
                                              .collection("message")
                                              .doc(res[index].id)
                                              .update({
                                            "isSeen": true,
                                          }).then((value) {
                                            log("is seen true");
                                          });
                                        }
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoAlertDialog(
                                              title: GestureDetector(
                                                onTap: () async {
                                                  log(res.first
                                                      .data()["message"]
                                                      .toString());
                                                  if (data["sender"]
                                                          .toString() ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                          .toString()) {
                                                    log(res.first
                                                        .data()["message"]
                                                        .toString());
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("chatRoom")
                                                        .doc(widget
                                                            .chatRoomModel.id)
                                                        .collection("message")
                                                        .doc(res[index].id)
                                                        .delete()
                                                        .then((value) async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "chatRoom")
                                                          .doc(widget
                                                              .chatRoomModel.id)
                                                          .update({
                                                        "last_message": res
                                                                    .length ==
                                                                1
                                                            ? ""
                                                            : snapshot
                                                                .data!.docs[1]
                                                                .data()[
                                                                    "message"]
                                                                .toString(),
                                                        "last_message_time":
                                                            Timestamp
                                                                .fromMillisecondsSinceEpoch(
                                                          DateTime.now()
                                                              .millisecondsSinceEpoch,
                                                        ),
                                                      }).then(
                                                        (value) =>
                                                            Navigator.pop(
                                                                context),
                                                      );
                                                    });
                                                  } else {
                                                    log("can not delete");
                                                  }
                                                },
                                                child: Text(
                                                  "Unseen message",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    data["sender"] ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8,
                                                    ),
                                                    child: LimitedBox(
                                                      maxWidth: width * 0.65,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: width * 0.05,
                                                          right: width * 0.03,
                                                          top: height * 0.007,
                                                          bottom:
                                                              height * 0.007,
                                                        ),
                                                        color: data["sender"] ==
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid
                                                            ? Colors.blue
                                                            : AppColor.grey
                                                                .withOpacity(
                                                                0.5,
                                                              ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              data["message"]
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.01,
                                                            ),
                                                            data["sender"] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid
                                                                ? data["isSeen"] ==
                                                                        true
                                                                    ? const Icon(
                                                                        Icons
                                                                            .done,
                                                                        size:
                                                                            15,
                                                                      )
                                                                    : Container()
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    data["sender"] ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .start,
                                                children: [
                                                  Text(
                                                    DateFormat("hh:mm").format(
                                                      DateTime
                                                          .fromMicrosecondsSinceEpoch(
                                                        data["time"]
                                                            .microsecondsSinceEpoch,
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      color: AppColor.grey,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Say! hi to your friend",
                                          style: TextStyle(
                                            color: AppColor.blue,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            messageController =
                                                TextEditingController(
                                              text: "hello",
                                            );
                                            sendMessage();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                          ),
                                          child: const Text("hello"),
                                        ),
                                      ],
                                    ),
                                  );
                          } else {
                            return Container();
                          }
                        }
                      },
                    ),
                  )
                : const Center(
                    child: Text("No data found"),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        color: Colors.grey.withOpacity(0.4),
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            hintText: "Type msg...",
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(
                      Icons.telegram_outlined,
                      size: 45,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
