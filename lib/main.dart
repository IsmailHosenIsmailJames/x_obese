import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:timezone/data/latest.dart" as tz;
import "package:x_obese/app.dart";
import "package:x_obese/src/core/health/my_health_functions.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/screens/auth/repository/auth_repository.dart";

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
  SharedPreferences preferences = await SharedPreferences.getInstance();
  tz.initializeTimeZones();
  await MyHealthFunctions.init();

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: App(prefs: preferences),
    ),
  );
}
