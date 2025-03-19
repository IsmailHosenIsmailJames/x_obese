import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';
import 'package:dio/dio.dart' as dio;

class AuthController extends GetxController {
  static DioClient dioClient = DioClient(baseAPI);

  Future<dio.Response?> signup(String phone) async {
    final response = await dioClient.post(signUpPath, data: {'mobile': phone});

    printResponse(response);

    if (response.statusCode == 201) {
      showToastMessageFromResponse(response);
      return response;
    } else {
      showToastMessageFromResponse(response);
      return null;
    }
  }

  Future<dio.Response?> login(String phone) async {
    final response = await dioClient.post(logInPath, data: {'mobile': phone});

    printResponse(response);

    if (response.statusCode == 201) {
      showToastMessageFromResponse(response);
      return response;
    } else {
      showToastMessageFromResponse(response);
      return null;
    }
  }

  Future<dio.Response?> verifyOTP(String otp, String type, String id) async {
    final data = {'code': '889327', 'type': type};
    log(jsonEncode(data), name: 'body');
    log(id, name: 'id');

    final response = await dioClient.post(
      '$verifyOTPPath/$id',
      data: {'code': otp, 'type': type},
    );

    printResponse(response);

    if (response.statusCode == 201) {
      showToastMessageFromResponse(response);
      return response;
    } else {
      showToastMessageFromResponse(response);
      return null;
    }
  }

  Future<dio.Response?> getUserData(String phone) async {
    final response = await dioClient.get(getUserDataPath);
    printResponse(response);
    showToastMessageFromResponse(response);

    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }
}

void printResponse(dio.Response response) {
  log(jsonEncode(response.data), name: 'response_status');
  log(response.statusCode.toString(), name: 'response_body');
}

void showToastMessageFromResponse(dio.Response response) {
  try {
    String message = response.data['message'] ?? '';
    Fluttertoast.showToast(msg: message);
  } catch (e) {
    log(e.toString(), name: 'error_message');
  }
}



//{"success":true,"message":"SIGNUP is successful","data":{"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImE1ZjdhODlhLTQ0YzUtNDQyMy05ODRjLTZkZjBhZDBlYTljZiIsImlhdCI6MTc0MjM0NTY5MH0.PkUUllmHskZ-2QfDK8opyHAL2YDq0LxTFLP8Oy3WA8o"}}