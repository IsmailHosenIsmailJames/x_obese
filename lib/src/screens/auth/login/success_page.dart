import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class LoginSuccessPage extends StatelessWidget {
  const LoginSuccessPage({super.key});

  Future<void> autoRoute(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => true);
  }

  @override
  Widget build(BuildContext context) {
    autoRoute(context);
    return Scaffold(
      body: Center(
        child: SvgPicture.asset("assets/img/intro/success_screen.svg"),
      ),
    );
  }
}
