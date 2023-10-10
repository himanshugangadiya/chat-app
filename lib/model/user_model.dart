class UserModel {
  String? uId;
  String? name;
  String? email;

  UserModel({required this.uId, required this.name, required this.email});

  UserModel.fromMap(Map<String, dynamic> map) {
    uId = map["uId"];
    name = map["name"];
    email = map["email"];
  }
  Map<String, dynamic> toMap() {
    return {
      "uId": uId,
      "name": name,
      "email": email,
    };
  }
}
