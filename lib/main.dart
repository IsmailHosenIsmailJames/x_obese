import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:timezone/data/latest.dart" as tz;
import "package:x_obese/app.dart";
import "package:x_obese/src/core/health/my_health_functions.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/screens/auth/repository/auth_repository.dart";

bool isUpdateChecked = false;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterForegroundTask.initCommunicationPort();

  await UserDB.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  tz.initializeTimeZones();
  await MyHealthFunctions.init();

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: const App(),
    ),
  );
}
