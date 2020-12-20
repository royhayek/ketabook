class Cart {
  String id;
  String userId;
  String bookId;
  String ownerId;
  String orderId;
  String quantity;
  String price;
  String serviceFee;
  String deliveryFee;
  String priceService;

  Cart({
    this.id,
    this.userId,
    this.bookId,
    this.ownerId,
    this.orderId,
    this.quantity,
    this.price,
    this.serviceFee,
    this.deliveryFee,
    this.priceService,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['user_id'],
      bookId: json['book_id'],
      ownerId: json['owner_id'],
      orderId: json['order_id'],
      quantity: json['quantity'],
      price: json['price'],
      serviceFee: json['service_fee'],
      deliveryFee: json['delivery_fee'],
      priceService: json['price_service'],
    );
  }
}
