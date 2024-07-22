import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecordModal {
  int? fileCount;
  Timestamp? addedAt;
  String? fileUrl;
  String? userId;

  String? userName;

  MedicalRecordModal(
      {this.fileCount, this.addedAt, this.fileUrl, this.userId, this.userName});

  MedicalRecordModal.fromJson(dynamic json) {
    fileCount = json["file_count"];
    addedAt = json["added_at"];
    fileUrl = json["file_url"];
    userId = json["user_id"];

    userName = json["user_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["file_count"] = fileCount;
    map["added_at"] = addedAt;
    map["file_url"] = fileUrl;
    map["user_id"] = userId;

    map["user_name"] = userName;
    return map;
  }
}
