class DeliveryTime {
  String id;
  String deliveryTimeEn;
  String deliveryTimeAr;

  DeliveryTime({this.id, this.deliveryTimeEn, this.deliveryTimeAr});

  factory DeliveryTime.fromJson(Map<String, dynamic> json) {
    return DeliveryTime(
      id: json['id'],
      deliveryTimeEn: json['delivery_timeEn'],
      deliveryTimeAr: json['delivery_timeAr'],
    );
  }
}
