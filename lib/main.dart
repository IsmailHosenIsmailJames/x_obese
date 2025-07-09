import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:get/get.dart";
import "package:timezone/data/latest.dart" as tz;
import "package:hive_flutter/hive_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/src/core/health/my_health_functions.dart";
import "package:x_obese/app.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/auth/controller/auth_controller.dart";

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterForegroundTask.initCommunicationPort();

  await Hive.initFlutter();
  await Hive.openBox("user");
  await Hive.openBox("tokens");

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  final authController = Get.put(AuthController());
  authController.refreshToken.value = await getRefreshToken();
  authController.accessToken.value = await getAccessToken();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  tz.initializeTimeZones();
  await MyHealthFunctions.init();

  runApp(App(prefs: preferences));
}
