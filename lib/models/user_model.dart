import 'base_model.dart';

class User extends BaseModel {
  String name;
  int? gender;
  String email;
  String password;
  String? phone;
  DateTime? dateOfBirth;
  String? address;
  String? avatar;

  User({
    super.id,
    required this.name,
    required this.email,
    required this.password,
    this.gender,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.avatar,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = 0,
  });
  @override
  String get tableName => 'users';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender':gender,
      'email': email,
      'password': password,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
      'avatar': avatar,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    print(json['createdAt']);
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      avatar: json['avatar'],
      isDeleted:  json['isDelete']?? 0,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

}
