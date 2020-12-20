class OrderObject {
  String userId; //user submit order
  String bookOwner; //user own the book
  String name;
  String phone;
  String address;
  String selectTime;
  String deliveryFee;
  String totalPrice; //price_service + delivery fee
  String dateOrder;
  String timeOrder;
  String statusCode;
  String bookImage;

  String bookId = "";
  String quantity = "";
  String price = "";
  String serviceFee = "";
  String priceService = "";

  OrderObject({
    this.userId,
    this.bookOwner,
    this.name,
    this.phone,
    this.address,
    this.selectTime,
    this.deliveryFee,
    this.totalPrice,
    this.dateOrder,
    this.timeOrder,
    this.statusCode,
    this.bookId,
    this.quantity,
    this.price,
    this.serviceFee,
    this.priceService,
    this.bookImage,
  });

  factory OrderObject.fromJson(Map<String, dynamic> json) {
    return OrderObject(
      userId: json['user_id'],
      bookOwner: json['book_owner'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      selectTime: json['selectTime'],
      deliveryFee: json['deliveryFee'],
      totalPrice: json['totalPrice'],
      dateOrder: json['date_order'],
      timeOrder: json['time_order'],
      statusCode: json['status_code'],
      bookId: json['book_id'],
      quantity: json['quantity'],
      price: json['price'],
      serviceFee: json['service_fee'],
      priceService: json['price_service'],
      bookImage: json['book_image'],
    );
  }
}
