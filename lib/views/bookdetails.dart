import 'dart:convert';
import 'package:mybookassignment/models/user.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';
import 'package:mybookassignment/views/undevelop/editbookpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookDetails extends StatefulWidget {
  final User user;
  final Book book;

  const BookDetails({
    super.key,
    required this.user,
    required this.book,
  });

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  late double screenWidth, screenHeight;
  final f = DateFormat('dd-MM-yyyy hh:mm a');
  bool bookowner = false;
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.user.userid == widget.book.userId) {
      bookowner = true;
    } else {
      bookowner = false;
    }
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomSheet: Container(
          width: 400,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity of books to be ordered    : ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text('$quantity', style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            // Use ?? to provide a default value (0 in this case) if bookQty is null
                            double bookQty =
                                double.parse(widget.book.bookQty ?? '0');

                            // Now you can compare and increment quantity
                            if (quantity < bookQty) {
                              quantity++;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (quantity > 0) {
                    addToCart();
                  } else {
                    // Tampilkan popup jika quantity = 0
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Cannot Add to Cart"),
                          content: Text(
                              "Quantity is 0. Please select a quantity greater than 0."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_shopping_cart,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(widget.book.bookTitle.toString()),
          // actions: [
          //   PopupMenuButton(itemBuilder: (context) {
          //     return [
          //       PopupMenuItem<int>(
          //         value: 0,
          //         enabled: bookowner,
          //         child: const Text("Update"),
          //       ),
          //       PopupMenuItem<int>(
          //         enabled: bookowner,
          //         value: 1,
          //         child: const Text("Delete"),
          //       ),
          //     ];
          //   }, onSelected: (value) {
          //     if (value == 0) {
          //       if (widget.book.userId == widget.book.userId) {
          //         updateDialog();
          //       } else {
          //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //           content: Text("Not allowed!!!"),
          //           backgroundColor: Colors.red,
          //         ));
          //       }
          //     } else if (value == 1) {
          //       if (widget.book.userId == widget.book.userId) {
          //         deleteDialog();
          //       } else {
          //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //           content: Text("Not allowed!!!"),
          //           backgroundColor: Colors.red,
          //         ));
          //       }
          //     } else if (value == 2) {}
          //   }),
          // ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.4,
                width: screenWidth,
                child: Image.network(
                  "${MyServerConfig.server}/assets/books/${widget.book.bookId}.png",
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                height: screenHeight * 0.6,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.book.bookTitle.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.book.bookAuthor.toString(),
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Date Available ${f.format(DateTime.parse(widget.book.bookDate.toString()))}",
                    ),
                    Text("ISBN ${widget.book.bookIsbn}"),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.book.bookDesc.toString(),
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      "RM ${widget.book.bookPrice}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Quantity Available ${widget.book.bookQty}"),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void updateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update this book?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => EditBookPage(
                              user: widget.user,
                              book: widget.book,
                            )));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Canceled"),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  void deleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this book?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteBook();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Canceled"),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  void deleteBook() {
    http.post(Uri.parse("${MyServerConfig.server}/api/delete_book.php"), body: {
      "userid": widget.user.userid.toString(),
      "bookid": widget.book.bookId.toString(),
    }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (content) => const LoginPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  void addToCart() {
    if (widget.user.userid.toString() == "0" ||
        widget.user.username.toString() == "Unregistered") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please register an account"),
        backgroundColor: Colors.red,
      ));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add to Cart'),
            content: Text('Do you want to add this item to the cart?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  insertToCart();
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item added to cart!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    }
  }

  void insertToCart() {
    http.post(
      Uri.parse("${MyServerConfig.server}/api/insert_cart.php"),
      body: {
        "userid": widget.user.userid.toString(),
        "book_id": widget.book.bookId.toString(),
        "cart_qty": quantity.toString(),
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = response.body;
        print("Response body: $data");

        try {
          var jsonData = jsonDecode(data);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Book Succes."),
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
