import "dart:developer";
import "dart:io";

import "package:fluttertoast/fluttertoast.dart";
import "package:permission_handler/permission_handler.dart";

Future<void> requestPermissions() async {
  final PermissionStatus notificationPermission =
      await Permission.notification.status;
  if (notificationPermission != PermissionStatus.granted) {
    await Permission.notification.request();
  }

  var ignoreBatteryOpt = await Permission.ignoreBatteryOptimizations.status;
  if (ignoreBatteryOpt != PermissionStatus.granted && Platform.isAndroid) {
    ignoreBatteryOpt = await Permission.ignoreBatteryOptimizations.request();
  }

  if (Platform.isAndroid) {
    if (!await Permission.ignoreBatteryOptimizations.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    if (!await Permission.scheduleExactAlarm.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }
  }
  try {
    if (Platform.isAndroid) {
      bool status = await Permission.activityRecognition.isGranted;
      if (!status) {
        PermissionStatus requestStatus =
            await Permission.activityRecognition.request();
        if (!requestStatus.isGranted) {
          Fluttertoast.showToast(msg: "Please allow access Physical activity");
          await openAppSettings();
        }
      }
      log(status.toString(), name: "Permission status");
    }
  } catch (e) {
    log(e.toString(), name: "Permission error");
  }
}
