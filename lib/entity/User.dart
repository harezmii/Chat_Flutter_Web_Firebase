class User {
  String imageUrl;
  String userName;
  String userDescription;
  String token;

  User({required this.imageUrl, required this.userName, required this.userDescription, required this.token});
  //
  // User.fromJson(Map<String, dynamic> json) {
  //   imageUrl = json['imageUrl'];
  //   userName = json['userName'];
  //   userDescription = json['userDescription'];
  //   token = json['token'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['imageUrl'] = this.imageUrl;
  //   data['userName'] = this.userName;
  //   data['userDescription'] = this.userDescription;
  //   data['token'] = this.token;
  //   return data;
  // }
}
