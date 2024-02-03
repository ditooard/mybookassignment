import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mybookassignment/models/cart.dart';
import 'package:mybookassignment/models/user.dart';
import 'package:mybookassignment/shared/myserverconfig.dart';
import 'package:http/http.dart' as http;
import 'package:mybookassignment/views/billscreen.dart';

class LoadCartPage extends StatefulWidget {
  final User userdata;
  const LoadCartPage({super.key, required this.userdata});

  @override
  _LoadCartPageState createState() => _LoadCartPageState();
}

class _LoadCartPageState extends State<LoadCartPage> {
  List<Cart> cartList = <Cart>[];

  @override
  void initState() {
    super.initState();
    final userid = widget.userdata.userid ?? "defaultUserID";
    loadCart(userid);
  }

  @override
  Widget build(BuildContext context) {
    final userid = widget.userdata.userid ?? "defaultUserID";
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: cartList.isEmpty
          ? const Center(child: Text("No Data"))
          : ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cartList[index].bookTitle.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity: ${cartList[index].cartQty}"),
                      Text(
                          "Price per book: RM ${cartList[index].bookPrice.toDouble()}"),
                      Text(
                          "Shipping Cost: RM ${calculateShippingCost(cartList[index].cartQty)}"),
                      Text("Total: RM ${calculateTotalPrice(index)}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Fungsi untuk menghapus buku dari keranjang
                          if (widget.userdata.userid != null) {
                            deleteCart(widget.userdata.userid!, index);
                          } else {
                            // Handle null case if needed
                            print("User ID is null");
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Total Books:  ${calculateTotalBooks()}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Total Price: RM ${calculateTotalPriceWithShipping()}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => BillScreen(
                                user: widget.userdata,
                                totalprice: calculateTotalPriceWithShipping()
                              )));
                  loadCart(userid);
                },
                child: const Text("Pay Now"))
          ],
        ),
      ),
    );
  }

  int calculateTotalBooks() {
    int totalBooks = 0;
    for (var cart in cartList) {
      totalBooks += cart.cartQty;
    }
    return totalBooks;
  }

  double calculateTotalPrice(int index) {
    double total =
        (cartList[index].cartQty.toDouble() * cartList[index].bookPrice) +
            calculateShippingCost(cartList[index].cartQty);
    return total;
  }

  double calculateShippingCost(int quantity) {
    return 10.0;
  }

  double calculateTotalPriceWithShipping() {
    double totalPrice = 0.0;
    for (var cart in cartList) {
      totalPrice += calculateTotalPrice(cartList.indexOf(cart));
    }
    return totalPrice;
  }

  void loadCart(String userid) {
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/api/load_cart.php?userid=$userid"),
    )
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        print(response.body);
        if (data['status'] == "success") {
          // Clear existing cartList before adding new items
          setState(() {
            cartList.clear();
            // Check if 'books' is not null and not empty
            if (data['data']['carts'] != null &&
                (data['data']['carts'] as List).isNotEmpty) {
              (data['data']['carts'] as List).forEach((v) {
                cartList.add(Cart.fromJson(v));
              });
            }
          });
          print("success");
        } else {
          print("failed");
        }
      }
    });
  }

  void deleteCart(String userid, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content:
              Text("Are you sure you want to remove this item from the cart?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                // User confirmed, proceed with deletion
                Navigator.of(context).pop(); // Close the dialog
                performDelete(userid, index);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void performDelete(String userid, int index) {
    final cartId = cartList[index].cartId;

    http
        .delete(Uri.parse(
            "${MyServerConfig.server}/api/delete_cart.php?userid=$userid&cartid=$cartId"))
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        print(response.body);
        if (data['status'] == "success") {
          setState(() {
            cartList.removeAt(index);
          });

          // Show a success dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success"),
                content: Text("Item removed from cart."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );

          print("success");
        } else {
          // Show a failure dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Failed"),
                content: Text("Failed to remove item from cart."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );

          print("failed");
        }
      }
    });
  }
}
