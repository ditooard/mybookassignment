import 'package:flutter/material.dart';

class LoadCartPage extends StatefulWidget {
  @override
  _LoadCartPageState createState() => _LoadCartPageState();
}

class _LoadCartPageState extends State<LoadCartPage> {
  List<Books> booksInCart = [
    Books("Book Title 1", 1, 25.0),
    Books("Book Title 2", 2, 30.0),
    Books("Book Title 3", 3, 20.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: ListView.builder(
        itemCount: booksInCart.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(booksInCart[index].title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Quantity: ${booksInCart[index].quantity}"),
                Text("Price per book: RM${booksInCart[index].price}"),
                Text(
                    "Shipping Cost: RM${calculateShippingCost(booksInCart[index].quantity)}"),
                Text("Total: RM${calculateTotalPrice(index)}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    // Fungsi untuk mengurangi jumlah buku dari keranjang
                    decrementQuantity(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Fungsi untuk menambah jumlah buku dari keranjang
                    incrementQuantity(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Fungsi untuk menghapus buku dari keranjang
                    removeBook(index);
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
              "Total Harga: RM${calculateTotalPriceWithShipping()}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Fungsi untuk melanjutkan ke proses pembayaran atau tindakan selanjutnya
                // bisa ditambahkan di sini
              },
              child: Text("Checkout"),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice(int index) {
    double total = (booksInCart[index].quantity * booksInCart[index].price) +
        calculateShippingCost(booksInCart[index].quantity);
    return total;
  }

  double calculateShippingCost(int quantity) {
    return 10.0 * quantity; // Ongkos kirim RM10 per buku
  }

  double calculateTotalPriceWithShipping() {
    double totalPrice = 0.0;
    for (var book in booksInCart) {
      totalPrice += calculateTotalPrice(booksInCart.indexOf(book));
    }
    return totalPrice;
  }

  void removeBook(int index) {
    setState(() {
      booksInCart.removeAt(index);
    });
  }

  void incrementQuantity(int index) {
    setState(() {
      booksInCart[index].quantity++;
    });
  }

  void decrementQuantity(int index) {
    if (booksInCart[index].quantity > 1) {
      setState(() {
        booksInCart[index].quantity--;
      });
    }
  }
}

class Books {
  final String title;
  int quantity;
  final double price;

  Books(this.title, this.quantity, this.price);
}
