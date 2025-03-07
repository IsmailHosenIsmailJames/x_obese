import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:o_xbese/src/screens/auth/info_collector/info_collector.dart';
import 'package:o_xbese/src/screens/auth/login/login_signup_page.dart';
import 'package:o_xbese/src/screens/intro/intro_page.dart';
import 'package:o_xbese/src/screens/navs/naves_page.dart';
import 'package:o_xbese/src/theme/colors.dart';

class OXbese extends StatelessWidget {
  const OXbese({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyAppColors.primary,
          brightness: Brightness.light,
        ),
        fontFamily: 'Montserrat',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.all(10),
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
      getPages: [
        GetPage(name: '/intro', page: () => IntroPage()),
        GetPage(name: '/login', page: () => LoginSignupPage()),
        GetPage(name: '/home', page: () => NavesPage()),
        GetPage(name: '/infoCollector', page: () => InfoCollector()),
      ],
      initialRoute:
          Hive.box('user').get('info', defaultValue: null) == null
              ? '/intro'
              : (Hive.box('user').get('info', defaultValue: null)
                      as Map)['name'] ==
                  null
              ? '/infoCollector'
              : '/home',
      onInit: () async {
        FlutterNativeSplash.remove();
      },
    );
  }
}
