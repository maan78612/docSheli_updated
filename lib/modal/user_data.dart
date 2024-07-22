import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  bool? isActive;
  int? role;
  String? phone;
  String? imageUrl;
  String? dob;
  String? name;
  bool? isMale;
  Timestamp? createAt;

  UserData(
      {this.isActive,
      this.role,
      this.phone,
      this.imageUrl,
      this.dob,
      this.name,
      this.isMale,
      this.createAt});

  UserData.fromJson(dynamic json) {
    isActive = json["is_active"];
    role = json["role"];
    phone = json["phone"];
    imageUrl = json["image_url"];
    dob = json["dob"];
    name = json["name"];
    isMale = json["is_male"];
    createAt = json["create_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["is_active"] = isActive;
    map["role"] = role;
    map["phone"] = phone;
    map["image_url"] = imageUrl;
    map["dob"] = dob;
    map["name"] = name;
    map["is_male"] = isMale;
    map["create_at"] = createAt;
    return map;
  }
}
