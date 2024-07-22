





import 'package:docsheli/constants/firebase_collections.dart';
import 'package:docsheli/modal/appointment.dart';

class AppointmentServices {
  static Future<Stream<List<AppointmentModal>>> appointmentList() async {
    var ref = FBCollections.appointments.snapshots().asBroadcastStream();
    var x = ref.map((event) =>
        event.docs.map((e) => AppointmentModal.fromJson(e.data())).toList());
    return x;
  }

// static temp() async {
//   QuerySnapshot ref = await FBCollections.medicalRecords.get();
//
//   print(jsonEncode(ref.docs.first.data()));
// }
}
