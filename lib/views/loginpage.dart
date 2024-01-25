// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:mybookassignment/views/mainpage.dart';

import '../shared/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _isObscure =
      true; // Menambahkan variabel untuk menentukan apakah teks tersembunyi atau tidak

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
        title: const Text(
          "Login Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/bg.jpg"),
              Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Column(
                        children: [
                          const Text(
                            "E - BOOK LOGIN",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: _emailEditingController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                            ),
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Please enter a valid email"
                                : null,
                          ),
                          TextFormField(
                            controller: _passEditingController,
                            keyboardType: TextInputType.text,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Please enter password"
                                : null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? value) {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        saveRemovePref(value!);
                                        setState(() {
                                          _isChecked = value;
                                        });
                                      },
                                    ),
                                    const Text("Remember Me"),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _loginUser();
                                },
                                child: const Text("Login"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;

    http.post(
      Uri.parse("${MyServerConfig.server}/api/login_user.php"),
      body: {"email": _email, "password": _pass},
    ).then((response) {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Success"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (content) => MainPage(userdata: user),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  void saveRemovePref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('rem', value);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preferences Stored"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('rem', false);
      _emailEditingController.text = '';
      _passEditingController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preferences Removed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('rem')) ?? false;
    if (_isChecked) {
      _emailEditingController.text = email;
      _passEditingController.text = password;
    }
    setState(() {});
  }
}
