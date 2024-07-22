

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/constants/firebase_collections.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/specialityModal.dart';

class DoctorServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Stream<List<DoctorInfo>>> fetchAllDoctors() async {
    Query query = FBCollections.doctorsInfo;

    var ref = query.snapshots().asBroadcastStream();
    List<DoctorInfo> doctors = [];
    var x = ref.map((event) =>
        event.docs.map((e) => DoctorInfo.fromJson(e.data())).toList());
    return Future.value(x);
  }

  Future<SpecialityModal?> specialityById(String id) async {
    DocumentSnapshot doc = await FBCollections.speciality.doc(id).get();
    SpecialityModal? speciality;
    if (doc.exists) {
      speciality = SpecialityModal.fromJson(doc.data());
    }
    return Future.value(speciality);
  }
}
