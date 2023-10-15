class UserModel {
  String? uId;
  String? name;
  String? email;
  String? profilePicture;

  UserModel(
      {required this.uId,
      required this.name,
      required this.email,
      required this.profilePicture});

  UserModel.fromMap(Map<String, dynamic> map) {
    uId = map["uId"];
    name = map["name"];
    email = map["email"];
    profilePicture = map["profile_picture"];
  }
  Map<String, dynamic> toMap() {
    return {
      "uId": uId,
      "name": name,
      "profile_picture": profilePicture,
    };
  }
}
