class Cart {
  int cartId;
  int bookId;
  int cartQty;
  String bookTitle;
  double bookPrice;

  Cart({
    required this.cartId,
    required this.bookId,
    required this.cartQty,
    required this.bookTitle,
    required this.bookPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'],
      bookId: json['book_id'],
      cartQty: json['cart_qty'],
      bookTitle: json['book_title'],
      bookPrice: json['book_price'].toDouble(),
    );
  }
}
