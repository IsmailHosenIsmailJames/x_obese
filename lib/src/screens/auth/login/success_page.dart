import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:x_obese/src/screens/navs/naves_page.dart";
import "package:x_obese/src/theme/colors.dart";

class LoginSuccessPage extends StatelessWidget {
  const LoginSuccessPage({super.key});

  Future<void> autoRoute(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const NavesPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    autoRoute(context);
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: Center(
        child: SvgPicture.asset("assets/img/intro/success_screen.svg"),
      ),
    );
  }
}
