import 'dart:developer';

import 'package:chat_app/helper/firebase_helper.dart';
import 'package:chat_app/model/chatroom_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/authentication/sign_up_screen.dart';
import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:chat_app/screens/home/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userModel;
  dynamic currentUserInfo() async {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot response =
        await FirebaseFirestore.instance.collection("users").doc(uId).get();

    userModel = UserModel.fromMap(response.data() as Map<String, dynamic>);

    print(userModel!.email);
    print(userModel!.uId);
    print(userModel!.name);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(FirebaseAuth.instance.currentUser!.email.toString()),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                    (route) => false,
                  );
                }).catchError((e) {
                  print(e.toString());
                });
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatRoom")
              .where("users",
                  arrayContains: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              if (snapshot.hasData) {
                List res = snapshot.data!.docs;
                return res.isNotEmpty
                    ? ListView.builder(
                        itemCount: res.length,
                        itemBuilder: (context, index) {
                          var data = res[index].data();
                          ChatRoomModel chatRoomModel =
                              ChatRoomModel.fromMap(data);

                          Map participantsMap = chatRoomModel.participants;
                          List participantsList = participantsMap.keys.toList();
                          participantsList
                              .remove(FirebaseAuth.instance.currentUser!.uid);
                          return FutureBuilder(
                            future: FirebaseHelper()
                                .getUserById(participantsList[0]),
                            builder: (context, snapshot) {
                              var date = DateTime.fromMillisecondsSinceEpoch(
                                  chatRoomModel
                                      .lastMessageTime!.millisecondsSinceEpoch);
                              if (snapshot.hasData) {
                                UserModel userModel =
                                    snapshot.data as UserModel;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    print(chatRoomModel.id
                                                        .toString());
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("chatRoom")
                                                        .doc(chatRoomModel.id)
                                                        .delete()
                                                        .then((value) {
                                                      log("chatroom deleted");
                                                      Navigator.pop(context);
                                                    });
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
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            chatRoomModel: chatRoomModel,
                                            targetUserName:
                                                userModel.name.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 100,
                                      color: Colors.grey.shade100,
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(userModel.name.toString()),
                                              chatRoomModel.lastMessage != ''
                                                  ? Text(chatRoomModel
                                                      .lastMessage
                                                      .toString())
                                                  : const Text(
                                                      "Say! hi to your frd",
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateFormat("hh:mm a")
                                                    .format(date),
                                              ),
                                              StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("chatRoom")
                                                    .doc(chatRoomModel.id)
                                                    .collection("message")
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Text(snapshot.error
                                                          .toString()),
                                                    );
                                                  } else {
                                                    if (snapshot.hasData) {
                                                      var res =
                                                          snapshot.data!.docs;
                                                      List data = res
                                                          .where((element) =>
                                                              element["sender"]
                                                                  .toString() !=
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                                  .toString())
                                                          .where((element) =>
                                                              element[
                                                                  "isSeen"] ==
                                                              false)
                                                          .toList();

                                                      return Text(
                                                        "${data.length}",
                                                      );
                                                    } else {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(
                  userModel: userModel,
                ),
              ),
            );
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
