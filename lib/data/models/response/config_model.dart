// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';


ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  ConfigModel({
    required this.version,
    required this.force,
    required this.about,
    required this.contact,
    required this.maintenance,
    required this.razorpay,
    required this.razorpayName,
    required this.terms,
    required this.privacyPolicy,
  });

  String? version;
  String? force;
  String? about;
  Contact? contact;
  String? maintenance;
  String? razorpay;
  String? razorpayName;
  String? terms;
  String? privacyPolicy;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    version: json["version"],
    force: json["force"],
    about: json["about"],
    contact: json["contact_us"] == null ? null : Contact.fromJson(json["contact_us"]),
    maintenance: json["maintenance"],
    razorpay: json["razorpay"] == null ? null : json["razorpay"]??'',
    razorpayName: json["razorpay_name"],
    terms: json['terms'] == null ? null : json['terms']!.trim(),
    privacyPolicy: json['privacy'] == null ? null : (json['privacy']??'').trim(),
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "about": about,
    "contact_us": contact == null ? null : contact!.toJson(),
    "maintenance": maintenance,
    "razorpay": razorpay,
    "razorpay_name": razorpayName,
    "terms": terms,
    "privacy": privacyPolicy,
  };
}

class Contact {
  Contact({
    this.phone,
    this.email,
    this.facebook,
    this.instagram,
  });

  String? phone;
  String? email;
  String? facebook;
  String? instagram;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    phone: json["phone"],
    email: json["email"],
    facebook : json["facebook"],
    instagram : json["instagram"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "email": email,
    "facebook": facebook,
    "instagram": instagram,
  };
}