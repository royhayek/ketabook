class PageDesc {
  String id;
  String name;
  String contentEn;
  String contentAr;

  PageDesc({
    this.id,
    this.name,
    this.contentEn,
    this.contentAr,
  });

  factory PageDesc.fromJson(Map<String, dynamic> json) {
    return PageDesc(
      id: json['id'],
      name: json['name'],
      contentEn: json['content_en'],
      contentAr: json['content_ar'],
    );
  }
}
