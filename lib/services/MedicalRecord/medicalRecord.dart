

import 'package:docsheli/constants/firebase_collections.dart';
import 'package:docsheli/modal/medical_record.dart';

class MedicalRecordServices {
  static Future<Stream<List<MedicalRecordModal>>> medicalRecordList(
      String userID) async {
    var ref = FBCollections.medicalRecords
        .where("user_id", isEqualTo: userID)
        .snapshots()
        .asBroadcastStream();
    var x = ref.map((event) =>
        event.docs.map((e) => MedicalRecordModal.fromJson(e.data())).toList());
    return x;
  }

  // static temp() async {
  //   QuerySnapshot ref = await FBCollections.medicalRecords.get();
  //
  //   print(jsonEncode(ref.docs.first.data()));
  // }
}
