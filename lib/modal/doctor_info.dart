import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DoctorInfo {
  List<String> availableDays;
  String? qualification;
  String? license;
  List<String> availableSlots;
  int? experience;
  String? hospital;
  String userId;
  DocumentReference? userRef;
  String? specialityId;

  DoctorInfo({
    required this.userId,
    this.availableDays = const [],
    this.qualification,
    this.availableSlots = const [],
    this.experience,
    this.license,
    this.hospital,
    this.userRef,
    this.specialityId,
  });

  DoctorInfo.fromJson(dynamic json)
      : availableDays = json["available_days"] != null
      ? List<String>.from(json["available_days"])
      : [],
        qualification = json["qualification"],
        availableSlots = json["available_slots"] != null
            ? List<String>.from(json["available_slots"])
            : [],
        experience = json["experience"],
        license = json["license"],
        userId = json["userId"],
        hospital = json["hospital"],
        userRef = json["user_ref"],
        specialityId = json["specialityId"];

  Map<String, dynamic> toJson() {
    return {
      "available_days": availableDays,
      "qualification": qualification,
      "available_slots": availableSlots,
      "experience": experience,
      "license": license,
      "userId": userId,
      "hospital": hospital,
      "user_ref": userRef,
      "specialityId": specialityId,
    };
  }
}

class DoctorLocation {
  dynamic lng;
  dynamic lat;

  DoctorLocation({this.lng, this.lat});

  DoctorLocation.fromJson(dynamic json)
      : lng = json["lng"],
        lat = json["lat"];

  Map<String, dynamic> toJson() {
    return {
      "lng": lng,
      "lat": lat,
    };
  }
}
