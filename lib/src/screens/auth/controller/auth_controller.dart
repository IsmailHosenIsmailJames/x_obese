import 'package:get/get.dart';

class AuthController extends GetxController {
  Future<bool> login(String phone) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> verifyOTP(String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
