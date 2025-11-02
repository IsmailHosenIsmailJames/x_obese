import "dart:convert";
import "dart:developer";

import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:dio/dio.dart" as dio;
import "package:intl/intl.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";

class ActivityController extends GetxController {
  DioClient dioClient = DioClient(baseAPI);

  Future<dio.Response?> saveActivity(Map data, int steps) async {
    try {
      log(jsonEncode(data), name: "saveActivity_Data_send");
      final dio.Response response = await dioClient.dio.post(
        "/api/user/v1/workout",
        data: data,
      );
      printResponse(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          DateTime now = DateTime.now();
          final response = await dioClient.dio.post(
            "/api/user/v1/workout/steps",
            data: {
              "steps": steps,
              "createdAt": DateFormat("yyyy-MM-dd").format(now),
            },
          );
          log(response.data.toString(), name: "workout/steps");
        } on Exception catch (e) {
          log(e.toString(), name: "Steps Save error");
        }
        final message = response.data["message"] ?? "";
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
    int steps,
    String userID,
  ) async {
    try {
      final dio.Response response = await dioClient.dio.patch(
        "/api/marathon/v1/user/$userID",
        data: data,
      );
      printResponse(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          DateTime now = DateTime.now();
          final response = await dioClient.dio.post(
            "/api/user/v1/workout/steps",
            data: {
              "steps": steps,
              "createdAt": DateFormat("yyyy-MM-dd").format(now),
            },
          );
          log(response.data.toString(), name: "workout/steps");
        } on Exception catch (e) {
          log(e.toString(), name: "Steps Save error");
        }
        final message = response.data["message"] ?? "";
        Fluttertoast.showToast(msg: message);
        return response;
      }
    } on dio.DioException catch (e) {
      printResponse(e.response!);
    }
    return null;
  }
}
