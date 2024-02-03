//Buyer page

import 'dart:convert';
import 'dart:developer';
import 'package:mybookassignment/models/book.dart';
import 'package:mybookassignment/models/user.dart';
import 'package:mybookassignment/shared/mydrawer.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';
import 'package:mybookassignment/views/bookdetails.dart';
import 'package:mybookassignment/views/cartpage.dart';
import 'package:mybookassignment/views/undevelop/newbookpage.dart';
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

  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  var color;
  String title = "";
  String author = "";

  @override
  void initState() {
    super.initState();
    loadBooks(title, author);
  }

  bool isSearchVisible = false;
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: buildSearchBar(),
        backgroundColor: Colors.orange,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
              });
            },
          ),
        ],
      ),
      drawer: MyDrawer(
        page: "books",
        userdata: widget.userdata,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshBooks(author, title);
        },
        child: bookList.isEmpty
            ? const Center(child: Text("No Data"))
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text("Page $curpage/$numofresult"),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(bookList.length, (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async {
                              Book book =
                                  Book.fromJson(bookList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => BookDetails(
                                            user: widget.userdata,
                                            book: book,
                                          )));
                              loadBooks(title, author);
                            },
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: Container(
                                    width: screenWidth,
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.network(
                                        fit: BoxFit.fill,
                                        "${MyServerConfig.server}/assets/books/${bookList[index].bookId}.png"),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        truncateString(bookList[index]
                                            .bookTitle
                                            .toString()),
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
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        //build the list for textbutton with scroll
                        if ((curpage - 1) == index) {
                          //set current page number active
                          color = Colors.red;
                        } else {
                          color = Colors.black;
                        }
                        return TextButton(
                            onPressed: () {
                              curpage = index + 1;
                              loadBooks(title, author);
                            },
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color, fontSize: 18),
                            ));
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadChart,
        child: const Icon(Icons.shopping_cart, color: Colors.white,),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void loadChart() {
    if (widget.userdata.userid.toString() == "0" ||
        widget.userdata.username.toString() == "Unregistered") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please register an account"),
        backgroundColor: Colors.red,
      ));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoadCartPage(
                  userdata: widget.userdata,
                )),
      );
    }
  }

  void newBook() {
    if (widget.userdata.userid.toString() == "0" ||
        widget.userdata.username.toString() == "Unregistered") {
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

  Future<void> refreshBooks(String title, author) async {
    await Future.delayed(Duration(seconds: 2));
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/api/load_books.php?title=$title&author=$author&pageno=$curpage&"),
    )
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          bookList.clear();
          data['data']['books'].forEach((v) {
            bookList.add(Book.fromJson(v));
          });
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
        } else {
          //if no status failed
        }
      }
      setState(() {});
    });
  }

  void loadBooks(String title, author) {
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/api/load_books.php?title=$title&author=$author&pageno=$curpage&"),
    )
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          bookList.clear();
          data['data']['books'].forEach((v) {
            bookList.add(Book.fromJson(v));
          });
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
          print(response.body);
        } else {
          //if no status failed
        }
      }
      setState(() {});
    });
  }

  Widget buildSearchBar() {
    TextEditingController searchCtrl = TextEditingController();

    return Stack(
      children: [
        Visibility(
          visible: !isSearchVisible,
          child: Container(
            child: Center(
              child: Text(
                "Books List",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isSearchVisible,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        title = searchCtrl.text;
                        author = searchCtrl.text;
                        loadBooks(searchCtrl.text, searchCtrl.text);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        isSearchVisible = false;
                        searchCtrl.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
