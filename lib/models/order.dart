class Order {
  String id;
  String userId; //user submit order
  String cartId; //user own the book
  String name;
  String phone;
  String address;
  String selectTime;
  String deliveryFee;
  String totalPrice; //price_service + delivery fee
  String dateOrder;
  String timeOrder;
  String statusCode;
  String orderCode;
  String bookImage;

  Order({
    this.id,
    this.userId,
    this.cartId,
    this.name,
    this.phone,
    this.address,
    this.selectTime,
    this.deliveryFee,
    this.totalPrice,
    this.dateOrder,
    this.timeOrder,
    this.statusCode,
    this.orderCode,
    this.bookImage,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      cartId: json['cart_id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      selectTime: json['selectTime'],
      deliveryFee: json['deliveryFee'],
      totalPrice: json['totalPrice'],
      dateOrder: json['date_order'],
      timeOrder: json['time_order'],
      statusCode: json['status_code'],
      orderCode: json['order_code'],
      bookImage: json['book_image'],
    );
  }
}
