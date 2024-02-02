//Profile page

import 'package:mybookassignment/shared/mydrawer.dart';
import 'package:mybookassignment/views/loginpage.dart';
import 'package:mybookassignment/views/registrationpage.dart';
import 'package:flutter/material.dart';
import 'package:mybookassignment/views/update/updatemail.dart';
import 'package:mybookassignment/views/update/updatename.dart';
import 'package:mybookassignment/views/update/updatepass.dart';

import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  final User userdata;
  const ProfilePage({super.key, required this.userdata});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //CircleAvatar(backgroundImage: AssetImage('')),
                Text(
                  "My Account",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            )),
        drawer: MyDrawer(
          page: 'account',
          userdata: widget.userdata,
        ),
        body: Center(
          child: Column(children: [
            Container(
              height: screenHeight * 0.25,
              padding: const EdgeInsets.all(4),
              child: Card(
                  child: Row(children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.4,
                  child: Image.asset(
                    'assets/images/profile.png',
                    color: Colors.orange,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Text(
                          widget.userdata.username.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Divider(
                          color: Colors.blueGrey,
                        )
                      ],
                    ))
              ])),
            ),
            Container(
              height: screenHeight * 0.035,
              alignment: Alignment.center,
              color: Colors.orange,
              width: screenWidth,
              child: const Text("UPDATE ACCOUNT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            // const Divider(
            //   color: Colors.blueGrey,
            // ),
            Expanded(
                child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    shrinkWrap: true,
                    children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => UpdateNameScreen(
                                    user: widget.userdata,
                                  )));
                    },
                    child: const Text("UPDATE NAME"),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => UpdateEmailScreen(
                                    user: widget.userdata,
                                  )));
                    },
                    child: const Text("UPDATE EMAIL"),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => UpdatePasswordScreen(
                                    user: widget.userdata,
                                  )));
                    },
                    child: const Text("UPDATE PASSWORD"),
                  ),
                  const Divider(
                    height: 2,
                  ),
                ])),
          ]),
        ));
  }
}
