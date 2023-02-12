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
  UserModel({
    this.uid,
    this.number,
    this.name,
    this.status,
    this.profilePhoto,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data.addAll({"uid": uid});
    data.addAll({"phone_number": number});
    data.addAll({"name": name});
    data.addAll({"status": status});
    data.addAll({"profilePhoto": profilePhoto});

    return data;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    number = json['phone_number'];
    name = json['name'];
    status = json['status'];
    profilePhoto = json['profilePhoto'];
  }

  UserModel copyWith({String? uid, String? number, String? name, String? profilePhoto, String? status}) {
    return UserModel(
      uid: uid ?? this.uid,
      number: number ?? this.number,
      name: name ?? this.name,
      status: status ?? this.status,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}
