import 'package:flutter/material.dart';
import 'package:mybookassignment/models/cart.dart';
import 'package:mybookassignment/models/user.dart';

class LoadCartPage extends StatefulWidget {
  final User userdata;
  const LoadCartPage({super.key, required this.userdata});

  @override
  _LoadCartPageState createState() => _LoadCartPageState();
}

class _LoadCartPageState extends State<LoadCartPage> {
  List<Cart> bookList = <Cart>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: bookList.isEmpty
          ? const Center(child: Text("No Data"))
          : Column(
  children: [
    Expanded(
      child: ListView.builder(
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () async {
                Book book = Book.fromJson(bookList[index].toJson());
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => BookDetails(
                      user: widget.userdata,
                      book: book,
                    ),
                  ),
                );
                loadBooks(title, author);
              },
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      "${MyServerConfig.server}/mybookassignment/assets/books/${bookList[index].bookId}.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        truncateString(bookList[index].bookTitle.toString()),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text("RM ${bookList[index].bookPrice}"),
                      Text("Available ${bookList[index].bookQty} unit"),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  ],
),

    );
  }
}
