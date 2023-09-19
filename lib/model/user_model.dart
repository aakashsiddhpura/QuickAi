
class UserModel {
  String uid;
  String displayName;
  String email;

  UserModel({this.uid = '', this.displayName = '', this.email = ''});

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] ?? '',
        displayName = json['displayName'] ?? '',
        email = json['email'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
    };
  }
}