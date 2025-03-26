import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

Future<bool> checkAndRequestPermission() async {
  ActivityPermission permission =
      await FlutterActivityRecognition.instance.checkPermission();
  if (permission == ActivityPermission.PERMANENTLY_DENIED) {
    // permission has been permanently denied.
    return false;
  } else if (permission == ActivityPermission.DENIED) {
    permission = await FlutterActivityRecognition.instance.requestPermission();
    if (permission != ActivityPermission.GRANTED) {
      // permission is denied.
      return false;
    }
  }

  return true;
}
