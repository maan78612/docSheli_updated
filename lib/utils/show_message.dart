import 'package:bot_toast/bot_toast.dart';

class ShowMessage {
  static showToast({required String msg, bool isError = false}) {
    BotToast.showText(text: msg, duration: Duration(seconds: 3));
  }
}
