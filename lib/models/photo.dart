class Photo {
  String id;
  String fId;
  String photo;

  Photo({
    this.id,
    this.fId,
    this.photo,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      fId: json['f_id'],
      photo: json['photo'],
    );
  }
}
