import "dart:convert";
import "dart:developer";

import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:dio/dio.dart" as dio;

class AuthController extends GetxController {
  static DioClient dioClient = DioClient(baseAPI);
  Rx<String?> refreshToken = Rx(null);
  Rx<String?> accessToken = Rx(null);

  Future<dio.Response?> signup(String phone) async {
    try {
      final response = await dioClient.dio.post(
        signUpPath,
        data: {"mobile": phone},
      );

      printResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showToastMessageFromResponse(response);
        return response;
      } else {
        showToastMessageFromResponse(response);
        return null;
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "No Message");
      if (e.response != null) {
        showToastMessageFromResponse(e.response!);
        printResponse(e.response!);
      }
    }
    return null;
  }

  Future<dio.Response?> login(String phone) async {
    try {
      final response = await dioClient.dio.post(
        logInPath,
        data: {"mobile": phone},
      );

      printResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showToastMessageFromResponse(response);
        return response;
      } else {
        showToastMessageFromResponse(response);
        return null;
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "No Message");
      if (e.response != null) {
        showToastMessageFromResponse(e.response!);
        printResponse(e.response!);
      }
    }
    return null;
  }

  Future<dio.Response?> verifyOTP(String otp, String type, String id) async {
    final data = {"code": "889327", "type": type};
    log(jsonEncode(data), name: "body");
    log(id, name: "id");

    final response = await dioClient.dio.post(
      "$verifyOTPPath/$id",
      data: {"code": otp, "type": type},
    );

    printResponse(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showToastMessageFromResponse(response);
      return response;
    } else {
      showToastMessageFromResponse(response);
      return null;
    }
  }

  Future<dio.Response?> getUserData(String phone) async {
    final response = await dioClient.dio.get(getUserDataPath);
    printResponse(response);
    showToastMessageFromResponse(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      return null;
    }
  }
}

void showToastMessageFromResponse(dio.Response response) {
  try {
    String message = response.data["message"] ?? "";
    Fluttertoast.showToast(msg: message);
  } catch (e) {
    log(e.toString(), name: "error_message");
  }
}
