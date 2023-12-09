//Buyer page

import 'dart:convert';
import 'package:mybookassignment/models/book.dart';
import 'package:mybookassignment/models/user.dart';
import 'package:mybookassignment/shared/mydrawer.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';
import 'package:mybookassignment/views/newbookpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final User userdata;
  const MainPage({super.key, required this.userdata});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Book> bookList = <Book>[];
  late double screenWidth, screenHeight;
  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  int axiscount = 2;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //CircleAvatar(backgroundImage: AssetImage('')),
              Text(
                "Book List",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          )),
      drawer: MyDrawer(
        page: "books",
        userdata: widget.userdata,
      ),
      body: bookList.isEmpty
          ? const Center(child: Text("No Data"))
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(bookList.length, (index) {
                      return Card(
                          child: Column(
                        children: [
                          Flexible(
                            flex: 6,
                            child: Container(
                              width: screenWidth,
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                  fit: BoxFit.fill,
                                  "${MyServerConfig.server}/mybookassignment/assets/books/${bookList[index].bookId}.png"),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  truncateString(
                                      bookList[index].bookTitle.toString()),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text("RM ${bookList[index].bookPrice}"),
                                Text(
                                    "Available ${bookList[index].bookQty} unit"),
                              ],
                            ),
                          )
                        ],
                      ));
                    }),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: newBook,
        child: const Icon(Icons.add),
      ),
    );
  }

  void newBook() {
    if (widget.userdata.userid.toString() == "0" || widget.userdata.username.toString() == "Unregistered") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please register an account"),
        backgroundColor: Colors.red,
      ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewBookPage(
                    userdata: widget.userdata,
                  )));
    }
  }

  String truncateString(String str) {
    if (str.length > 20) {
      str = str.substring(0, 20);
      return str + "...";
    } else {
      return str;
    }
  }

  void loadBooks() {
    http.get(Uri.parse("${MyServerConfig.server}/mybookassignment/php/load_books.php"),
        headers: {
          // Tambahkan header jika diperlukan
        }).then((http.Response response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(response.body);
        if (data['status'] == "success") {
          bookList.clear();
          for (var bookData in data['data']) {
            bookList.add(Book.fromJson(bookData));
          }
        } else {
          print('Gagal memuat data buku. Status: ${data['status']}');
        }
      } else {
        print('Gagal memuat data buku. Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
      setState(() {});
    }).catchError((error, stackTrace) {
      print('Error: $error');
      print('Stack Trace: $stackTrace');
      // Tangani kesalahan di sini
    });
  }
}
