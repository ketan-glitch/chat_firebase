// To parse this JSON data, do
//
//     final statusModel = statusModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_firebase/data/models/response/user_model.dart';

List<StatusModel> statusModelFromJson(String str) => List<StatusModel>.from(json.decode(str).map((x) => StatusModel.fromJson(x)));

String statusModelToJson(List<StatusModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatusModel {
  StatusModel({
    this.image,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        image: json["image"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        createdAt: json["created_at"] == null ? null : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "user": user?.toJson(),
        "created_at": createdAt?.millisecondsSinceEpoch,
        "updated_at": updatedAt?.millisecondsSinceEpoch,
      };
}
