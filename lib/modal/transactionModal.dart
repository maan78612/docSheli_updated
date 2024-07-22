import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsModel {
  String? amount;
  int? appointmentType;
  String? paidTo;
  Timestamp? createdAt;
  String? paidBy;
  String? trxId;

  TransactionsModel(
      {this.amount,
      this.appointmentType,
      this.paidTo,
      this.createdAt,
      this.paidBy,
      this.trxId});

  TransactionsModel.fromJson(dynamic json) {
    amount = json["amount"];
    appointmentType = json["appointment_type"];
    paidTo = json["paid_to"];
    createdAt = json["created_at"];
    paidBy = json["paid_by"];
    trxId = json["trxId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["amount"] = amount;
    map["appointment_type"] = appointmentType;
    map["paid_to"] = paidTo;
    map["created_at"] = createdAt;
    map["paid_by"] = paidBy;
    map["trxId"] = trxId;
    return map;
  }
}
