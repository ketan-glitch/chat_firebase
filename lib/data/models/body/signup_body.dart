class SignUpBody {
  String? phone;
  String? email;
  String? name;
  String? dob;
  String? location;
  String? gender;
  String? deviceId;
  String? password;

  SignUpBody({
    this.name,
    this.email,
    this.phone,
    this.dob,
    this.gender,
    this.location,
    this.deviceId,
    this.password,
  });

  SignUpBody.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    name = json['name'];
    dob = json['dob'];
    location = json['location'];
    gender = json['gender'];
    deviceId = json['device_id'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['email'] = email;
    data['name'] = name;
    data['dob'] = dob;
    data['location'] = location;
    data['gender'] = gender;
    data['device_id'] = deviceId;
    data['password'] = password;
    return data;
  }
}
