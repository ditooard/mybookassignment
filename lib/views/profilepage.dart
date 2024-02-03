//Profile page

import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _image;

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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      showSelectionDialog();
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape
                            .circle, // Mengatur bentuk menjadi lingkaran
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image == null
                              ? const AssetImage("assets/images/camera.png")
                              : FileImage(_image!) as ImageProvider,
                        ),
                      ),
                    ),
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
}
