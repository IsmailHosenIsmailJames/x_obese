import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginSuccessPage extends StatelessWidget {
  final bool isSignUp;
  const LoginSuccessPage({super.key, required this.isSignUp});

  autoRoute() async {
    await Future.delayed(const Duration(seconds: 1));
    Get.offAllNamed(isSignUp ? '/nameCollectPage' : '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/img/intro/success_screen.svg'),
      ),
    );
  }
}
