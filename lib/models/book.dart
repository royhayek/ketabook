class Book {
  String id;
  String userId;
  String universityId;
  String collegeId;
  String specialityId;
  String name;
  String descp;
  String price;
  String serviceFee;
  String priceService;
  String deliveryFee;
  String statusCode;
  String datePost;
  String timePost;
  String photo;
  String isUpdateData;
  String limit;

  Book({
    this.id,
    this.userId,
    this.universityId,
    this.collegeId,
    this.specialityId,
    this.name,
    this.descp,
    this.price,
    this.serviceFee,
    this.deliveryFee,
    this.priceService,
    this.statusCode,
    this.datePost,
    this.timePost,
    this.photo,
    this.isUpdateData,
    this.limit,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      userId: json['user_id'],
      universityId: json['university_id'],
      collegeId: json['college_id'],
      specialityId: json['speciality_id'],
      name: json['name'],
      descp: json['descp'],
      price: json['price'],
      serviceFee: json['service_fee'],
      priceService: json['price_service'],
      deliveryFee: json['delivery_fee'],
      statusCode: json['status_code'],
      datePost: json['date_post'],
      timePost: json['time_post'],
      photo: json['photo'],
      isUpdateData: json['isUpdateData'],
    );
  }
}
