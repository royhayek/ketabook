class College {
  String id;
  String nameEn;
  String nameAr;
  String photo;
  String statusCode;
  String universityId;

  College(
      {this.id,
      this.nameEn,
      this.nameAr,
      this.photo,
      this.statusCode,
      this.universityId});

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      photo: json['photo'],
      statusCode: json['status_code'],
      universityId: json['university_id'],
    );
  }
}
