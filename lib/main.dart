import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:o_xbese/o_xbese.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';
import 'package:o_xbese/src/screens/auth/controller/auth_controller.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await Hive.openBox('user');
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
  runApp(const OXbese());
}
