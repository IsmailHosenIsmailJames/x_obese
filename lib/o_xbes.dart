import 'package:flutter/material.dart';
import 'package:o_xbes/src/screens/auth/success/success_page.dart';
import 'package:o_xbes/src/theme/colors.dart';

class OXbes extends StatelessWidget {
  const OXbes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyAppColors.primaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyAppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w900,
            fontSize: 34,
            color: Colors.black,
          ), //
          displayMedium: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w800,
            fontSize: 28,
            color: Colors.black,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.black,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w200,
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ),
      home: SuccessPage(),
    );
  }
}
