import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModal {
  String? trxId;
  String? doctorId, tmpDocName;
  String? patientID;
  String? fullName;
  int? appointmentType;
  int? gender;
  bool? paymentStatus;
  Timestamp? createdAt;
  Timestamp? appointmentDate;
  int? bookingFor;
  String? phoneNumber;
  Map<String, dynamic>? relationship;
  String? timeSlot;

  AppointmentModal(
      {this.trxId,
      this.doctorId,
      this.patientID,
      this.tmpDocName,
      this.fullName,
      this.appointmentType,
      this.gender,
      this.paymentStatus,
      this.createdAt,
      this.appointmentDate,
      this.bookingFor,
      this.phoneNumber,
      this.relationship,
      this.timeSlot});

  AppointmentModal.fromJson(dynamic json) {
    trxId = json["trx_id"];
    doctorId = json["doctor_id"];
    patientID = json["patient_id"];
    fullName = json["full_name"];
    appointmentType = json["appointment_type"];
    gender = json["gender"];
    paymentStatus = json["payment_status"];
    createdAt = json["created_at"];
    appointmentDate = json["appointment_date"];
    bookingFor = json["booking_for"];
    phoneNumber = json["phone_number"];
    relationship = json["relationship"];
    timeSlot = json["time_slot"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["trx_id"] = trxId;
    map["doctor_id"] = doctorId;
    map["patient_id"] = patientID;
    map["full_name"] = fullName;
    map["appointment_type"] = appointmentType;
    map["gender"] = gender;
    map["payment_status"] = paymentStatus;
    map["created_at"] = createdAt;
    map["appointment_date"] = appointmentDate;
    map["booking_for"] = bookingFor;
    map["phone_number"] = phoneNumber;
    map["relationship"] = relationship;
    map["time_slot"] = timeSlot;
    return map;
  }
}
