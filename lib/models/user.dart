class User {
  String? userid;
  String? useremail;
  String? username;
  String? phone;
  String? userpassword;
  String? userdatereg;

  User(
      {this.userid,
      this.useremail,
      this.username,
      this.phone,
      this.userpassword,
      this.userdatereg});

  User.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    useremail = json['useremail'];
    username = json['username'];
    phone = json['phone'];
    userpassword = json['userpassword'];
    userdatereg = json['userdatereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['useremail'] = useremail;
    data['username'] = username;
    data['phone'] = phone;
    data['userpassword'] = userpassword;
    data['userdatereg'] = userdatereg;
    return data;
  }
}
