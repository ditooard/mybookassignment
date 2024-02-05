//Profile page

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybookassignment/models/user_profile.dart';
import 'package:mybookassignment/shared/mydrawer.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:mybookassignment/views/update/updatemail.dart';
import 'package:mybookassignment/views/update/updatename.dart';
import 'package:mybookassignment/views/update/updatepass.dart';
import 'dart:convert';
import 'dart:developer';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  final User userdata;

  const ProfilePage({super.key, required this.userdata});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<UserProfile> userList = <UserProfile>[];
  late double screenWidth, screenHeight;
  File? _image;

  @override
  void initState() {
    super.initState();
    final userid = widget.userdata.userid ?? "defaultUserID";
    loadProfile(userid);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final userid = widget.userdata.userid ?? "defaultUserID";
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
        body: RefreshIndicator(
          onRefresh: () async {
            await refreshProfile(userid);
          },
          child: Center(
            child: Column(children: [
              Container(
                height: screenHeight * 0.29,
                padding: const EdgeInsets.all(4),
                child: Card(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: GestureDetector(
                              onTap: () {
                                showSelectionDialog();
                              },
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "${MyServerConfig.server}/assets/avatar/${userList.isNotEmpty ? userList[0].userphoto ?? "assets/images/camera.png" : "assets/images/camera.png"}",
                                    ) as ImageProvider,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextButton(
                              onPressed: () {
                                if (_image != null) {
                                  insertPhotos(context, userid, _image!);
                                } else {
                                  print("Error: Image kosong");
                                  // Handle the case where _image is empty, you can display a message or take appropriate action.
                                }
                              },
                              child: Text(
                                'Upload Foto',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Upload Photo Button

                      Expanded(
                        flex: 7,
                        child: ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (BuildContext context, int index) {
                            UserProfile user = userList[index];
                            return Column(
                              children: [
                                Text(
                                  '${user.username ?? "N/A"}',
                                  style: const TextStyle(fontSize: 24),
                                ),
                                // Add Text Widgets for other properties like username, phone, etc.
                                const Divider(
                                  color: Colors.blueGrey,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
          ),
        ));
  }

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                  child: const Text('Gallery'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                  child: const Text('Camera'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                ),
              ],
            ));
      },
    );
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset
            .square, // Mengatur aspek rasio menjadi square (bulat)
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset
              .square, // Mengatur aspek rasio awal menjadi square (bulat)
          lockAspectRatio: true, // Mengunci aspek rasio agar tetap square
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
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

  Future<void> refreshProfile(String userid) async {
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

  void insertPhotos(BuildContext context, String userId, File _image) {
    // Mengekstrak data gambar dari file dan mengonversinya menjadi string base64.
    String imagestr = base64Encode(_image!.readAsBytesSync());

    http.post(
      Uri.parse(
          "${MyServerConfig.server}/api/profilepic_update.php?userid=$userId"),
      body: {"avatar": imagestr},
    ).then((response) {
      if (response.statusCode == 200) {
        var data = response.body;
        print("Response body: $data");

        try {
          var jsonData = jsonDecode(data);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Photos Success."),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          print("Error decoding JSON: $e");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed. Error decoding JSON"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        // Penanganan kesalahan status HTTP selain 200
        print("HTTP Error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Insert Failed. HTTP Error"),
          backgroundColor: Colors.red,
        ));
      }
    }).catchError((error) {
      // Penanganan kesalahan selama request
      print("Error during HTTP request: $error");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Insert Failed. Error during request"),
        backgroundColor: Colors.red,
      ));
    });
  }
}
