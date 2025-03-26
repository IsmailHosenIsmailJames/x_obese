import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';

class ActivityController extends GetxController {
  DioClient dioClient = DioClient(baseAPI);

  Future<dio.Response?> saveActivity(Map data) async {
    try {
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
    } catch (e) {
      log(e.toString(), name: 'Error');
    }
    return null;
  }
}
