import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class FirebaseHelper {
  Future<UserModel> getUserById(String uId) async {
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection("users").doc(uId).get();

    UserModel userModel =
        UserModel.fromMap(userData.data() as Map<String, dynamic>);

    return userModel;
  }
}
