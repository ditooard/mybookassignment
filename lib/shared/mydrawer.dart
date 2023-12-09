import 'package:mybookassignment/views/loginpage.dart';
import 'package:mybookassignment/views/profilepage.dart';
import 'package:mybookassignment/views/sellerpage.dart';
import 'package:mybookassignment/views/registrationpage.dart';
import 'package:mybookassignment/views/settingpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/communitypage.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../views/mainpage.dart';
import 'EnterExitRoute.dart';

class MyDrawer extends StatefulWidget {
  final String page;
  final User userdata;

  const MyDrawer({Key? key, required this.page, required this.userdata})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    bool isUserRegistered = widget.userdata.username == "Unregistered";

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
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            currentAccountPicture: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/profile.png'),
                backgroundColor: Colors.white),
            accountName: Text(isUserRegistered
                ? widget.userdata.username.toString()
                : widget.userdata.username.toString()),
            accountEmail: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isUserRegistered
                      ? widget.userdata.useremail.toString()
                      : widget.userdata.useremail.toString()),
                  Text("RM100"),
                ],
              ),
            ),
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
          const Divider(
            color: Colors.blueGrey,
          ),
          ListTile(
            leading: const Icon(Icons.app_registration_rounded),
            title: const Text('Register'),
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
          ListTile(
            leading: const Icon(Icons.login_rounded),
            title:
                isUserRegistered ? const Text('Login') : const Text('Logout'),
            onTap: () {
              if (isUserRegistered) {
                print(widget.page.toString());
                if (widget.page.toString() == "login page") {
                  //  Navigator.pop(context);
                  return;
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (content) => const LoginPage()));
              } else {
                showLogoutConfirmationDialog(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('My Account'),
            onTap: () {
              print(widget.page.toString());
              Navigator.pop(context);
              if (widget.page.toString() == "account") {
                //  Navigator.pop(context);
                return;
              }
              Navigator.pop(context);

              // Navigator.push(context,
              //     MaterialPageRoute(builder: (content) => const ProfilePage()));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: ProfilePage(userdata: widget.userdata),
                      enterPage: ProfilePage(userdata: widget.userdata)));
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
        ],
      ),
    );
  }
}
