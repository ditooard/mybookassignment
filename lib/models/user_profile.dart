import 'package:flutter/material.dart';

class UserProfile {
  String? userid;
  String? useremail;
  String? username;
  String? phone;
  String? userpassword;
  String? userdatereg;
  String? userphoto;

  UserProfile(
      {this.userid,
      this.useremail,
      this.username,
      this.phone,
      this.userpassword,
      this.userdatereg,
      this.userphoto});

  UserProfile.fromJson(Map<String, dynamic> json) {
    userid = json['user_id'];
    useremail = json['user_email'];
    username = json['user_name'];
    phone = json['user_phone'];
    userpassword = json['user_password'];
    userdatereg = json['user_datereg'];
    userphoto = json['user_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userid;
    data['user_email'] = useremail;
    data['user_name'] = username;
    data['user_phone'] = phone;
    data['user_password'] = userpassword;
    data['user_datereg'] = userdatereg;
    data['user_photo'] = userphoto;
    return data;
  }
}
