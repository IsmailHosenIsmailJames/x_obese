import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/screens/home/home_page.dart';

class OXbese extends StatelessWidget {
  const OXbese({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      onInit: () async {
        FlutterNativeSplash.remove();
      },
      home: HomePage(),
    );
  }
}
