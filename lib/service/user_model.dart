class UserModel {
  String userId, email, name, pic;

  UserModel({this.userId, this.email, this.name, this.pic});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    userId = map['userId'];
    email = map['email'];
    name = map['name'];
  }

  toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
    };
  }
}
