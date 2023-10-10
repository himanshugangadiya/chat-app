import 'package:chat_app/model/chatroom_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoomModel chatRoomModel;
  final String targetUserName;
  const ChatScreen(
      {super.key, required this.chatRoomModel, required this.targetUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  var uuid = const Uuid();

  sendMessage() {
    String newMsgId = uuid.v1();
    if (messageController.text.isNotEmpty && messageController.text != '') {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.targetUserName.toString()),
        ),
        body: Column(
          children: [
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
                                            print("is seen true");
                                          });
                                        }
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: data["sender"] ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  color: data["sender"] ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  child: Text(
                                                    data["message"].toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat("hh:mm a")
                                                      .format(
                                                        DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                          data["time"]
                                                              .millisecondsSinceEpoch,
                                                        ),
                                                      )
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text("No msg"),
                                  );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
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
