class UserModel {
  String? id;
  String? name;
  String? email;
  String? about;
  String? avatar;
  String? signUpTime;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.avatar,
    required this.signUpTime,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    about = json['bio'];
    avatar = json['avatar'];
    signUpTime = json['signUpTime'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> userData = {};
    userData['id'] = id;
    userData['name'] = name;
    userData['email'] = email;
    userData['about'] = about;
    userData['avatar'] = avatar;
    userData['signUpTime'] = signUpTime;
    return userData;
  }
}
