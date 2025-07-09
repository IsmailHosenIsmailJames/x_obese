import "package:flutter/material.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/src/core/common/functions/is_information_fulfilled.dart";
import "package:x_obese/src/screens/auth/controller/auth_controller.dart";
import "package:x_obese/src/screens/controller/info_collector/info_collector.dart";
import "package:x_obese/src/screens/controller/info_collector/model/all_info_model.dart";
import "package:x_obese/src/screens/auth/login/login_signup_page.dart";
import "package:x_obese/src/screens/intro/intro_page.dart";
import "package:x_obese/src/screens/navs/naves_page.dart";
import "package:x_obese/src/theme/colors.dart";

class App extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final SharedPreferences prefs;
  const App({super.key, required this.prefs});
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      key: navigatorKey,
      theme: ThemeData(
        pageTransitionsTheme: pageTransitionsTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyAppColors.primary,
          brightness: Brightness.light,
        ),
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
      defaultTransition: Transition.leftToRight,
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      getPages: [
        GetPage(name: "/intro", page: () => const IntroPage()),
        GetPage(name: "/login", page: () => const LoginSignupPage()),
        GetPage(name: "/home", page: () => const NavesPage()),
        GetPage(
          name: "/infoCollector",
          page:
              () => InfoCollector(
                initialData: AllInfoModel.fromJson(
                  Hive.box("user").get("info"),
                ),
              ),
        ),
      ],
      initialRoute:
          Hive.box("user").get("info", defaultValue: null) == null
              ? "/intro"
              : isInformationNotFullFilled(
                AllInfoModel.fromJson(Hive.box("user").get("info")),
              )
              ? "/infoCollector"
              : (authController.refreshToken.value == null &&
                  authController.accessToken.value == null)
              ? "/login"
              : "/home",
      onInit: () async {
        FlutterNativeSplash.remove();
      },
    );
  }
}
