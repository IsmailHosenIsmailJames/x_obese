import 'dart:developer';

import 'package:get/get.dart';
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';
import 'package:o_xbese/src/screens/auth/controller/auth_controller.dart';
import 'package:o_xbese/src/screens/auth/info_collector/model/all_info_model.dart';
import 'package:dio/dio.dart' as dio;

class AllInfoController {
  static DioClient dioClient = DioClient(baseAPI);
  Rx<AllInfoModel> allInfo = Rx<AllInfoModel>(AllInfoModel());

  Future<dio.Response?> updateUserInfo(dynamic data) async {
    final response = await dioClient.patch(userDataPath, data: data);
    printResponse(response);
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }
}
