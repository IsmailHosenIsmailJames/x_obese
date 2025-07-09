
import "dart:developer";

import "package:dio/dio.dart" as dio;
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/common_functions/common_functions.dart";

class AuthRepository {
  static final DioClient _dioClient = DioClient(baseAPI);

  Future<dio.Response?> signup(String phone) async {
    try {
      final response = await _dioClient.dio.post(
        signUpPath,
        data: {"mobile": phone},
      );
      printResponse(response);
      return response;
    } on dio.DioException catch (e) {
      _handleDioError(e);
      return e.response;
    }
  }

  Future<dio.Response?> login(String phone) async {
    try {
      final response = await _dioClient.dio.post(
        logInPath,
        data: {"mobile": phone},
      );
      printResponse(response);
      return response;
    } on dio.DioException catch (e) {
      _handleDioError(e);
      return e.response;
    }
  }

  Future<dio.Response?> verifyOTP(String otp, String type, String id) async {
    try {
      final response = await _dioClient.dio.post(
        "$verifyOTPPath/$id",
        data: {"code": otp, "type": type},
      );
      printResponse(response);
      return response;
    } on dio.DioException catch (e) {
      _handleDioError(e);
      return e.response;
    }
  }

  Future<dio.Response?> getUserData() async {
    try {
      final response = await _dioClient.dio.get(getUserDataPath);
      printResponse(response);
      return response;
    } on dio.DioException catch (e) {
      _handleDioError(e);
      return e.response;
    }
  }

  void _handleDioError(dio.DioException e) {
    log(e.message ?? "No Message");
    if (e.response != null) {
      showToastMessageFromResponse(e.response!);
      printResponse(e.response!);
    }
  }
}
