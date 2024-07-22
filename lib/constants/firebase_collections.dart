import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FBCollections {
  static CollectionReference speciality = db.collection("specialities");

  static CollectionReference appointments = db.collection("appointments");
  static CollectionReference doctorsInfo = db.collection("doctorsInfo");
  static CollectionReference medicalRecords = db.collection("medicalRecords");
  static CollectionReference ratings = db.collection("ratings");
  static CollectionReference users = db.collection("users");
  static CollectionReference transactions = db.collection("transactions");
  static CollectionReference chats = db.collection("chats");
  static CollectionReference chatRooms = db.collection("chatRooms");
}
