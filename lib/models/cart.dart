class Cart {
  String? cartId;
  String? bookId;
  String? cartQty;
  String? bookTitle;
  String? bookPrice;

  Cart({
    this.cartId,
    this.bookId,
    this.cartQty,
    this.bookTitle,
    this.bookPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'],
      bookId: json['book_id'],
      cartQty: json['cart_qty'],
      bookTitle: json['book_title'],
      bookPrice: json['book_price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['book_id'] = bookId;
    data['cart_qty'] = cartQty;
    data['book_title'] = bookTitle;
    data['book_price'] = bookPrice;
    return data;
  }
}
