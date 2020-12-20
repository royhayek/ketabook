class DeliveryFee {
  String id;
  String fee;

  DeliveryFee({this.id, this.fee});

  factory DeliveryFee.fromJson(Map<String, dynamic> json) {
    return DeliveryFee(
      id: json['id'],
      fee: json['fee'],
    );
  }
}
