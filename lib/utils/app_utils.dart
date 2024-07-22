import 'package:cloud_firestore/cloud_firestore.dart';

class AppUtils {
  static String getFreshTimeStamp() {
    return Timestamp.now().millisecondsSinceEpoch.toString();
  }

  static String paymentTrxId = "";
  static String userAvatar =
      "https://firebasestorage.googleapis.com/v0/b/docsheli.appspot.com/o/iconfinder_984127_avatar_male_man_user_person_icon_512px.png?alt=media&token=d1677082-3dff-420e-b78a-f61ad06b7d1c";

  //
  static int getWeekDayByStringDay(String dayString) {
    var days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
    return days.indexWhere((element) => element == dayString) + 1;
  }
}
