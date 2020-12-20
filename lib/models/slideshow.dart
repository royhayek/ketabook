class Slideshow {
  String id = "0";
  String name = "NULL";
  String fileName = "NULL";
  String imgLink = "NULL";
  String orderN = "NULL";
  String titleEn = "NULL";
  String titleAr = "NULL";
  String descpEn = "NULL";
  String descpAr = "NULL";
  String createdDate = "NULL";
  String updatedDate = "NULL";

  Slideshow({
    this.id,
    this.name,
    this.fileName,
    this.imgLink,
    this.orderN,
    this.titleEn,
    this.titleAr,
    this.descpEn,
    this.descpAr,
    this.createdDate,
    this.updatedDate,
  });

  factory Slideshow.fromJson(Map<String, dynamic> json) {
    return Slideshow(
      id: json['id'],
      name: json['name'],
      fileName: json['file_name'],
      imgLink: json['img_link'],
      orderN: json['order_n'],
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      descpEn: json['descp_en'],
      descpAr: json['descp_ar'],
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
    );
  }
}
