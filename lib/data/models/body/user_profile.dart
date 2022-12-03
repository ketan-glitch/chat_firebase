import '../../../services/enums/gender.dart';

class UserBodyModel {
  UserBodyModel({
    this.name,
    this.contact,
    this.schoolId,
    this.dob,
    this.gender,
  });

  String? name;
  String? contact;
  String? schoolId;
  String? dob;
  Gender? gender;

  factory UserBodyModel.fromJson(Map<String, dynamic> json) => UserBodyModel(
        name: json["name"],
        contact: json["phone"],
        schoolId: json["school_id"],
        dob: json["date_of_birth"],
        gender: json["gender"] == null
            ? null
            : json["gender"] == 'male'
                ? Gender.male
                : Gender.female,
      );

  Map<String, String> toJson() => {
        if (name != null) "name": '$name',
        if (contact != null) "phone": '$contact',
        if (schoolId != null) "school_id": '$schoolId',
        if (gender != null) "gender": gender!.name.toLowerCase(),
        if (dob != null) "date_of_birth": '$dob',
      };
}
