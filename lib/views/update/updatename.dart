import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mybookassignment/models/user.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';

class UpdateNameScreen extends StatefulWidget {
  const UpdateNameScreen({
    super.key,
    required this.user,
  });

  final User user;

  @override
  _UpdateNameScreenState createState() => _UpdateNameScreenState();
}

class _UpdateNameScreenState extends State<UpdateNameScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  void _updateName() {
    String _username = _nameController.text;
    String? user_id = widget.user.userid;
    ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update Name Success"),
              backgroundColor: Colors.green,
            ),
          );
    

    print('$user_id');
    print('$_username');

    http
        .put(
      Uri.parse(
          "${MyServerConfig.server}/api/username_update.php?userid=$user_id&username=$_username"),
    )
        .then((response) {
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update Name Success"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update Name Failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle non-200 status code
        print("Non-200 status code: ${response.statusCode}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'New Name'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateName();
              },
              child: Text('Update Name'),
            ),
          ],
        ),
      ),
    );
  }
}
