import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:x_obese/src/core/common/functions/is_information_fulfilled.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/screens/auth/bloc/auth_state.dart";
import "package:x_obese/src/screens/auth/login/login_signup_page.dart";
import "package:x_obese/src/screens/info_collector/info_collector.dart";
import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";
import "package:x_obese/src/screens/intro/intro_page.dart";
import "package:x_obese/src/screens/navs/naves_page.dart";
import "package:x_obese/src/theme/colors.dart";

import "src/screens/activity/models/activity_types.dart";

class App extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final List<PositionNodes>? positionNodes;
  final bool? isPaused;
  final ActivityType? activityType;
  const App({super.key, this.positionNodes, this.isPaused, this.activityType});
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final PageTransitionsTheme pageTransitionsTheme =
        const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        );

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        UserInfoModel? userInfoModel = context.read<AuthBloc>().userInfoModel();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          key: navigatorKey,
          theme: ThemeData(
            pageTransitionsTheme: pageTransitionsTheme,
            colorScheme: ColorScheme.fromSeed(
              seedColor: MyAppColors.third,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: MyAppColors.primary,
            fontFamily: "Lexend",
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(10),
                backgroundColor: MyAppColors.second,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          themeMode: ThemeMode.light,
          darkTheme: ThemeData.dark(),
          routes: <String, WidgetBuilder>{
            "/intro": (BuildContext context) => const IntroPage(),
            "/login": (BuildContext context) => const LoginSignupPage(),
            "/home": (BuildContext context) => const NavesPage(),
            "/infoCollector": (BuildContext context) {
              final String? info = Hive.box("user").get("info");
              return InfoCollector(
                initialData: info != null ? UserInfoModel.fromJson(info) : null,
              );
            },
            "/workout": (BuildContext context) {
              return NavesPage(
                autoNavToWorkout: true,
                isPaused: isPaused,
                positionNodes: positionNodes,
                activityType: activityType,
              );
            },
          },
          initialRoute:
              (positionNodes != null && isPaused != null)
                  ? "/workout"
                  : userInfoModel == null
                  ? "/intro"
                  : isInformationNotFullFilled(userInfoModel)
                  ? userInfoModel.isGuest
                      ? "/home"
                      : "/infoCollector"
                  : (UserDB.accessToken() == null &&
                      UserDB.refreshToken() == null)
                  ? "/login"
                  : "/home",
        );
      },
    );
  }
}
