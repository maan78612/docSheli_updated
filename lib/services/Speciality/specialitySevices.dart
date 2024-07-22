

import 'package:docsheli/constants/firebase_collections.dart';
import 'package:docsheli/modal/specialityModal.dart';

class SpecialityServices {
  Future<List<SpecialityModal>> getSpecialities() async {
    var ref = await FBCollections.speciality.get();

    var specialities = ref.docs.map((e) => SpecialityModal.fromJson(e.data())).toList();

    return specialities;
  }
}
