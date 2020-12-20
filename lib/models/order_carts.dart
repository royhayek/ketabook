class OrderCarts {
  String id;
  String orderId; //user submit order
  String bookId; //user own the book

  OrderCarts({
    this.id,
    this.orderId,
    this.bookId,
  });

  factory OrderCarts.fromJson(Map<String, dynamic> json) {
    return OrderCarts(
      id: json['id'],
      orderId: json['order_id'],
      bookId: json['book_id'],
    );
  }
}
