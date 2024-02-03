import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mybookassignment/models/user.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({
    super.key,
    required this.user,
  });

  final User user;
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updatePass();
                print('Password updated successfully.');
                // Tampilkan pesan sukses atau handle kesalahan jika diperlukan
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Password updated successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePass() {
    String _currentPass = _currentPasswordController.text;
    String _newPass = _newPasswordController.text;
    String? user_id = widget.user.userid;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Update Password Success"),
        backgroundColor: Colors.green,
      ),
    );

    http
        .put(
      Uri.parse(
          "${MyServerConfig.server}/api/password_update.php?userid=$user_id&current_password=$_currentPass&password=$_newPass"),
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
              content: Text("Update Password Success"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update Password Failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }
}
