class Package {
  String id;
  String nameEn;
  String nameAr;
  String descriptionEn;
  String descriptionAr;
  String price;
  String booksLimit;
  String statusCode;

  Package({
    this.id,
    this.nameEn,
    this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
    this.price,
    this.booksLimit,
    this.statusCode,
  });

    factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      descriptionEn: json['descriptionEn'],
      descriptionAr: json['descriptionAr'],
      price: json['price'],
      booksLimit: json['books_limit'],
      statusCode: json['status_code'],
    );
  }
}
