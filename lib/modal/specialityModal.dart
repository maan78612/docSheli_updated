import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialityModal {
  Timestamp? addedAt;
  String? speciality;
  String? id;

  SpecialityModal({this.addedAt, this.speciality, this.id});

  SpecialityModal.fromJson(dynamic json) {
    addedAt = json["added_at"];
    speciality = json["speciality"];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["added_at"] = addedAt;
    map["speciality"] = speciality;
    map["id"] = id;
    return map;
  }
}
