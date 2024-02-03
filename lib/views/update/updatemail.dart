import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mybookassignment/models/user.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({
    super.key,
    required this.user,
  });

  final User user;
  @override
  _UpdateEmailScreenState createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'New Email'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateMail();
                String newEmail = _emailController.text;
                // Proses pembaruan email
                print('Email updated to: $newEmail');
                // Tampilkan pesan sukses atau handle kesalahan jika diperlukan
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Email updated successfully to $newEmail.'),
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
              child: Text('Update Email'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMail() {
    String _email = _emailController.text;
    String? user_id = widget.user.userid;
    ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update email Success"),
              backgroundColor: Colors.green,
            ),
          );
    http
        .put(
      Uri.parse(
          "${MyServerConfig.server}/api/useremail_update.php?userid=$user_id&email=$_email"),
    )
        .then((response) {
      print('$_email');
      print('$user_id');
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update email Success"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update email Failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }
}
