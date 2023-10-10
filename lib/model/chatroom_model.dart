import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? id;
  String? lastMessage;
  Timestamp? lastMessageTime;
  late Map<String, dynamic> participants;
  List<dynamic>? users;

  ChatRoomModel({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.participants,
    required this.users,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    lastMessage = map["last_message"];
    participants = map["participants"];
    users = map["users"];
    lastMessageTime = map["last_message_time"];
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "last_message": lastMessage,
      "last_message_time": lastMessageTime,
      "participants": participants,
      "users": users,
    };
  }
}
