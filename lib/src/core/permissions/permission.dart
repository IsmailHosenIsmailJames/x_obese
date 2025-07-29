import "dart:developer";
import "dart:io";

import "package:fluttertoast/fluttertoast.dart";
import "package:permission_handler/permission_handler.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<void> requestPermissions() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  final PermissionStatus notificationPermission =
      await Permission.notification.status;
  if (notificationPermission != PermissionStatus.granted) {
    await Permission.notification.request();
  }

  if (Platform.isAndroid) {
    bool? ignoreBatteryOptimizationsDenied = sharedPreferences.getBool(
      "ignoreBatteryOptimizationsDenied",
    );
    if (!await Permission.ignoreBatteryOptimizations.isGranted) {
      if (ignoreBatteryOptimizationsDenied != true) {
        PermissionStatus permissionStatus =
            await Permission.ignoreBatteryOptimizations.request();
        if (permissionStatus == PermissionStatus.denied ||
            permissionStatus == PermissionStatus.permanentlyDenied) {
          sharedPreferences.setBool("ignoreBatteryOptimizationsDenied", true);
        }
      }
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
