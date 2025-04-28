import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:x_obese/src/apis/apis_url.dart';
import 'package:x_obese/src/apis/middleware/jwt_middleware.dart';

class ActivityController extends GetxController {
  DioClient dioClient = DioClient(baseAPI);

  Future<dio.Response?> saveActivity(Map data) async {
    try {
      log(jsonEncode(data), name: 'saveActivity_Data_send');
      final dio.Response response = await dioClient.dio.post(
        '/api/user/v1/workout',
        data: data,
      );
      printResponse(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data['message'] ?? '';
        Fluttertoast.showToast(msg: message);
        return response;
      }
    } on dio.DioException catch (e) {
      printResponse(e.response!);
    }
    return null;
  }

  Future<dio.Response?> saveMarathonUserActivity(
    Map data,
    String userID,
  ) async {
    try {
      final dio.Response response = await dioClient.dio.patch(
        '/api/marathon/v1/user/$userID',
        data: data,
      );
      printResponse(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data['message'] ?? '';
        Fluttertoast.showToast(msg: message);
        return response;
      }
    } on dio.DioException catch (e) {
      printResponse(e.response!);
    }
    return null;
  }
}
