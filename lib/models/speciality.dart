class Speciality {
  String id;
  String nameEn;
  String nameAr;
  String photo;
  String statusCode;
  String collegeId;

  Speciality(
      {this.id,
      this.nameEn,
      this.nameAr,
      this.photo,
      this.statusCode,
      this.collegeId});

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      photo: json['photo'],
      statusCode: json['status_code'],
      collegeId: json['college_id'],
    );
  }
}
