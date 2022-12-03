// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

List<UserData> usersListFromJson(String str) => List<UserData>.from(json.decode(str).map((x) => UserData.fromJson(x)));

class UserModel {
  UserModel({
    required this.user,
  });

  UserData user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: UserData.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.image,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.deviceId,
    this.status,
    this.company,
    this.isAdmin,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? image;
  String? email;
  String? phone;
  String? company;
  String? gender;
  DateTime? dob;
  String? deviceId;
  String? isAdmin;
  String? status;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        gender: json["gender"] ?? '',
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        status: json["status"] ?? '',
        deviceId: json["device_id"] ?? '',
        company: json["company"] ?? '',
        isAdmin: json["isAdmin"] ?? '',
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "company": company,
        "image": image,
        "email": email,
        "phone": phone,
        "gender": gender,
        "dob": dob?.toIso8601String(),
        "isAdmin": isAdmin,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "device_id": deviceId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
