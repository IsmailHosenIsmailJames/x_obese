import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/screens/intro/intro_page.dart';
import 'package:o_xbese/src/screens/intro/pages/intro_page_1.dart';
import 'package:o_xbese/src/screens/intro/pages/intro_page_2.dart';
import 'package:o_xbese/src/screens/intro/pages/intro_page_3.dart';
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
      onInit: () async {
        FlutterNativeSplash.remove();
      },
      home: IntroPage(),
    );
  }
}
