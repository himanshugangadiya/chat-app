import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../model/chatroom_model.dart';
import '../../utils/app_color.dart';
import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  final dynamic userModel;
  const SearchScreen({super.key, required this.userModel});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  var uuid = const Uuid();
  ChatRoomModel? chatRoomModel;

  Future<ChatRoomModel?> createChatRoom(String targetUserID) async {
    ChatRoomModel? tempChatRoomModel;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatRoom")
        .where("participants.${FirebaseAuth.instance.currentUser!.uid}",
            isEqualTo: true)
        .where(
          "participants.$targetUserID",
          isEqualTo: true,
        )
        .get();

    if (snapshot.docs.length > 0) {
      var data = snapshot.docs[0].data();
      log(data.toString());
      log("already chatroom created ...............");
      ChatRoomModel existingModel =
          ChatRoomModel.fromMap(data as Map<String, dynamic>);
      tempChatRoomModel = existingModel;
    } else {
      String id = uuid.v1().toString();
      ChatRoomModel newChatRoom = ChatRoomModel(
        id: id,
        lastMessage: "",
        lastMessageTime: Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch),
        participants: {
          FirebaseAuth.instance.currentUser!.uid.toString(): true,
          targetUserID: true,
        },
        users: [
          FirebaseAuth.instance.currentUser!.uid.toString(),
          targetUserID.toString(),
        ],
      );
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(newChatRoom.id.toString())
          .set(newChatRoom.toMap())
          .then((value) {
        log("New chatroom created ...............");
      }).catchError((e) {
        log(e.toString());
      });

      tempChatRoomModel = newChatRoom;
    }
    return tempChatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            // horizontal: width * 0.05,
            vertical: height * 0.01,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.01,
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (val) {
                    setState(() {
                      searchText = val;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Search...",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else {
                        List responseData = snapshot.data!.docs;
                        List response = responseData
                            .where((element) => element["name"]
                                .toString()
                                .toLowerCase()
                                .contains(searchText.toString().toLowerCase()))
                            .toList();
                        return ListView.builder(
                          itemCount: response.length,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.02,
                          ),
                          itemBuilder: (context, index) {
                            var data = response[index];
                            return ListTile(
                              onTap: () async {
                                ChatRoomModel? chatRoomModel =
                                    await createChatRoom(data.data()["uId"]);

                                if (chatRoomModel != null) {
                                  log("chateRoomModel is not null");
                                  Get.back();
                                  Get.to(
                                    () => ChatScreen(
                                      chatRoomModel: chatRoomModel,
                                      targetUserName: data["name"].toString(),
                                      targetUserPhotoUrl:
                                          data["profile_picture"].toString(),
                                    ),
                                  );
                                } else {
                                  log("chatRoomModel is Null");
                                }
                              },
                              leading: data["profile_picture"] != ''
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data["profile_picture"].toString(),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: AppColor.blue,
                                      child: Text(
                                        data["name"]
                                            .toString()[0]
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ),
                              title: Text(data["name"].toString()),
                              subtitle: Text(data["email"].toString()),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
