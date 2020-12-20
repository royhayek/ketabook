class University {
  String id;
  String nameEn;
  String nameAr;
  String photo;
  String statusCode;

  University({this.id, this.nameEn, this.nameAr, this.photo, this.statusCode});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      photo: json['photo'],
      statusCode: json['status_code'],
    );
  }
}
