import 'package:chat_app/utils/app_color.dart';
import 'package:chat_app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  TextEditingController messageController = TextEditingController();
  var uuid = const Uuid();

  sendMessage({required String chatRoomModelId}) {
    String newMsgId = uuid.v1();
    if (messageController.text.trim().isNotEmpty &&
        messageController.text.trim() != '') {
      try {
        FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(chatRoomModelId)
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
              .doc(chatRoomModelId)
              .update({
            "last_message": messageController.text.trim().toString(),
            "last_message_time": Timestamp.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch,
            ),
          });
          messageController.clear();
        });
      } on FirebaseException catch (e) {
        showToast(
          message: e.message.toString(),
          color: AppColor.red,
        );
      }
    }
  }
}
