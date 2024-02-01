import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../shared/mydrawer.dart';

class SellerPage extends StatefulWidget {
  final User userdata;

  const SellerPage({super.key, required this.userdata});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //CircleAvatar(backgroundImage: AssetImage('')),
                Text(
                  "Order and Sales",
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
          page: "seller",
          userdata: widget.userdata,
        ),
        body: const Center(
          child: Text("ORDER AND SALES PAGE"),
        ));
  }
}
