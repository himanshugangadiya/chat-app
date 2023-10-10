import 'dart:developer';

import 'package:chat_app/screens/home/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../model/chatroom_model.dart';

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
      print(data.toString());
      print("already chatroom created ...............");
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
        print("New chatroom created ...............");
      }).catchError((e) {
        print(e.toString());
      });

      tempChatRoomModel = newChatRoom;
    }
    return tempChatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              TextField(
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
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: searchText.toString())
                      .where("email", isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List response = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: response.length,
                          itemBuilder: (context, index) {
                            var data = response[index];
                            return ListTile(
                              onTap: () async {
                                ChatRoomModel? chatRoomModel =
                                    await createChatRoom(data.data()["uId"]);

                                if (chatRoomModel != null) {
                                  log("chateRoomModel is not null");
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          chatRoomModel: chatRoomModel,
                                          targetUserName:
                                              data["name"].toString(),
                                        ),
                                      ));
                                } else {
                                  log("chateRoomModel is Null");
                                }
                              },
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
