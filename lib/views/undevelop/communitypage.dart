import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../shared/mydrawer.dart';

class CommunityPage extends StatefulWidget {
  final User userdata;

  const CommunityPage({super.key, required this.userdata});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.orange,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //CircleAvatar(backgroundImage: AssetImage('')),
                Text(
                  "Comunity",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            )),
        drawer: MyDrawer(
          page: "community",
          userdata: widget.userdata,
        ),
        body: const Center(
          child: Text("COMMUNITY PAGE"),
        ));
  }
}
