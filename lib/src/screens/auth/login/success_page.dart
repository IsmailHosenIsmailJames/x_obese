import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginSuccessPage extends StatelessWidget {
  const LoginSuccessPage({super.key});

  autoRoute() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    autoRoute();
    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/img/intro/success_screen.svg'),
      ),
    );
  }
}
