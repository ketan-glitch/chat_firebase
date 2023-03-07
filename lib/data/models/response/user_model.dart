import 'package:chat_firebase/services/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// A wrapper of [FirebaseUser] provides infomation to distinguish the initial value.
@immutable
class CurrentUser {
  final bool isInitialValue;
  final User data;

  const CurrentUser._(this.data, this.isInitialValue);
  factory CurrentUser.create(User data) => CurrentUser._(data, false);

  /// The inital empty instance.
// static const initial = CurrentUser._(null, true);
}

class UserModel {
  String? uid;
  String? number;
  String? name;
  String? status;
  String? profilePhoto;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel({
    this.uid,
    this.number,
    this.name,
    this.status,
    this.profilePhoto,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data.addAll({"uid": uid});
    data.addAll({"phone_number": number});
    data.addAll({"name": name});
    data.addAll({"status": status});
    data.addAll({"profilePhoto": profilePhoto});
    if (createdAt.isNotNull) data.addAll({"created_at": createdAt?.millisecondsSinceEpoch});
    if (updatedAt.isNotNull) data.addAll({"updated_at": updatedAt?.millisecondsSinceEpoch});

    return data;
  }

  Map<String, Object?> toJsonn() {
    Map<String, dynamic> data = {};
    data.addAll({"uid": uid});
    data.addAll({"phone_number": number});
    data.addAll({"name": name});
    data.addAll({"status": status});
    data.addAll({"profilePhoto": profilePhoto});
    if (createdAt.isNotNull) data.addAll({"created_at": createdAt?.millisecondsSinceEpoch});
    if (updatedAt.isNotNull) data.addAll({"updated_at": updatedAt?.millisecondsSinceEpoch});

    return data;
  }

  UserModel.fromJsonn(Map<String, Object?> json)
      : this(
          uid: json['uid']?.toString(),
          number: json['phone_number']?.toString(),
          name: json['name']?.toString(),
          status: json['status']?.toString(),
          profilePhoto: json['profilePhoto']?.toString(),
          createdAt: json['created_at'] == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse('${json['created_at']}')),
          updatedAt: json['updated_at'] == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse('${json['updated_at']}')),
        );

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    number = json['phone_number'];
    name = json['name'];
    status = json['status'];
    profilePhoto = json['profilePhoto'];
    createdAt = json['created_at'] == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse('${json['created_at']}'));
    updatedAt = json['updated_at'] == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse('${json['updated_at']}'));
  }

  UserModel copyWith({String? uid, String? number, String? name, String? profilePhoto, String? status, DateTime? createdAt, DateTime? updatedAt}) {
    return UserModel(
      uid: uid ?? this.uid,
      number: number ?? this.number,
      name: name ?? this.name,
      status: status ?? this.status,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '$name';
  }
}
