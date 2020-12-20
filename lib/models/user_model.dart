class UserModel {
  String name;
  String phone;
  String email;
  String password;
  String statusCode;
  String dateJoin;
  String timeJoin;
  String universityId;
  String id;
  String dob;
  String gender;
  String address;
  String packageId;

  UserModel({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.statusCode,
    this.dateJoin,
    this.timeJoin,
    this.universityId,
    this.id,
    this.dob,
    this.gender,
    this.address,
    this.packageId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      statusCode: json['status_code'],
      password: json['password'],
      dateJoin: json['date_join'],
      timeJoin: json['time_join'],
      universityId: json['university_id'],
      dob: json['dob'],
      gender: json['gender'],
      address: json['address'],
      packageId: json['package_id'],
    );
  }
}
