class Cart {
  String cartId;
  String bookId;
  int cartQty;
  String bookTitle;
  int bookPrice; 

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
      cartQty: int.tryParse(json['cart_qty'].toString()) ?? 0,
      bookTitle: json['book_title'],
      bookPrice: int.tryParse(json['book_price'].toString()) ?? 0,
    );
  }
}
