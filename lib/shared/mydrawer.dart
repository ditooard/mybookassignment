import 'package:mybookassignment/models/user_profile.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';
import 'package:mybookassignment/views/loginpage.dart';
import 'package:mybookassignment/views/profilepage.dart';
import 'package:mybookassignment/views/undevelop/sellerpage.dart';
import 'package:mybookassignment/views/registrationpage.dart';
import 'package:mybookassignment/views/undevelop/settingpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/undevelop/communitypage.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../views/mainpage.dart';
import 'EnterExitRoute.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class MyDrawer extends StatefulWidget {
  final String page;
  final User userdata;

  const MyDrawer({Key? key, required this.page, required this.userdata})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<UserProfile> userList = <UserProfile>[];
  @override
  void initState() {
    super.initState();
    final userid = widget.userdata.userid ?? "defaultUserID";
    loadProfile(userid);
  }

  @override
  Widget build(BuildContext context) {
    bool isUserUnregistered = widget.userdata.username == "Unregistered";

    void logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Hapus data login yang disimpan
      prefs.remove('email');
      prefs.remove('pass');
      prefs.remove('rem');
      widget.userdata.username = "Unregistered";
      widget.userdata.useremail = "unregistered@email.com";

      // Navigasi ke layar login atau halaman lain sesuai kebutuhan
      Navigator.pop(context);
    }

    void showLogoutConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Confirmation'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  logout();
                  Navigator.of(context)
                      .pop(); // Tutup dialog // Panggil fungsi logout jika user menekan "Logout"
                },
                child: Text('Logout'),
              ),
            ],
          );
        },
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            currentAccountPicture: ClipOval(
              child: Image.network(
                "${MyServerConfig.server}/assets/avatar/${userList.isNotEmpty ? userList[0].userphoto ?? "assets/images/camera.png" : "assets/images/camera.png"}",
                fit: BoxFit.cover,
                width: 50, // adjust the size as needed
                height: 50, // adjust the size as needed
              ),
            ),
            accountName: userList.isNotEmpty
                ? Text(
                    userList[0].username ?? "Unregisteredt",
                    style: const TextStyle(fontSize: 18),
                  )
                : const Text("Unregistered", style: TextStyle(fontSize: 18)),
            accountEmail: userList.isNotEmpty
                ? Text(
                    userList[0].useremail ?? "Unregistered",
                    style: const TextStyle(fontSize: 18),
                  )
                : const Text("Unregistered", style: TextStyle(fontSize: 18)),
            otherAccountsPictures: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.star, color: Colors.yellow),
              ),
              // Tambahkan widget lain jika diperlukan
            ],
          ),
          ListTile(
            leading: const Icon(Icons.sell),
            title: const Text('Orders and Sales'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "seller") {
                return;
              }
              Navigator.push(
                context,
                EnterExitRoute(
                  exitPage: SellerPage(userdata: widget.userdata),
                  enterPage: SellerPage(userdata: widget.userdata),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Community'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "community") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                EnterExitRoute(
                  exitPage: CommunityPage(userdata: widget.userdata),
                  enterPage: CommunityPage(userdata: widget.userdata),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Books'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "books") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                EnterExitRoute(
                  exitPage: MainPage(userdata: widget.userdata),
                  enterPage: MainPage(userdata: widget.userdata),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.blueGrey,
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('My Account'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "account") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                EnterExitRoute(
                  exitPage: ProfilePage(userdata: widget.userdata),
                  enterPage: ProfilePage(userdata: widget.userdata),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration_rounded),
            title: const Text('Register Account'),
            onTap: () {
              if (widget.page.toString() == "register") {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (content) => const RegistrationPage(),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.blueGrey,
          ),
          ListTile(
            leading: const Icon(Icons.login_rounded),
            title:
                isUserUnregistered ? const Text('Login') : const Text('Logout'),
            onTap: () {
              if (isUserUnregistered) {
                if (widget.page.toString() == "login page") {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => const LoginPage(),
                  ),
                );
              } else {
                showLogoutConfirmationDialog(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "setting") {
                return;
              }
              Navigator.push(
                context,
                EnterExitRoute(
                  exitPage: SettingPage(userdata: widget.userdata),
                  enterPage: SettingPage(userdata: widget.userdata),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  void loadProfile(String userid) {
    http
        .get(
      Uri.parse("${MyServerConfig.server}/api/profile.php?userid=$userid"),
    )
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        print(response.body);
        if (data['status'] == "success") {
          var userData = data['data'] as Map<String, dynamic>;
          // Bersihkan userList sebelum menambahkan data baru
          userList.clear();
          // Tambahkan data Map ke userList
          userList.add(UserProfile.fromJson(userData));
          print("success");

          // Pastikan untuk memanggil setState agar widget di-refresh
          setState(() {});
        } else {
          print("failed");
        }
      }
    });
  }
}
