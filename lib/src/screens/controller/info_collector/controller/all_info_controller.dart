import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';
import 'package:o_xbese/src/screens/controller/info_collector/model/all_info_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:o_xbese/src/screens/marathon/models/model.dart';
import 'package:o_xbese/src/screens/resources/workout/status.dart';

class AllInfoController extends GetxController {
  RxInt selectedPoints = 0.obs;
  RxString selectedCategory = 'Calories'.obs;
  RxInt stepsCount = 0.obs;

  static DioClient dioClient = DioClient(baseAPI);
  static Box userBox = Hive.box('user');

  Rx<AllInfoModel> allInfo = Rx<AllInfoModel>(AllInfoModel());
  RxList<WorkStatusModel> workStatus = RxList<WorkStatusModel>([
    WorkStatusModel(),
  ]);
  RxList<MarathonModel> marathonList = RxList<MarathonModel>([]);

  Future<dio.Response?> updateUserInfo(dynamic data) async {
    final response = await dioClient.dio.patch(userDataPath, data: data);
    printResponse(response);
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }

  Future<void> dataAsync() async {
    // get workout plan
    log('Try get workout plan', name: 'Try get workout plan');
    try {
      DioClient dioClient = DioClient(baseAPI);
      dio.Response response = await dioClient.dio.get(
        '/api/user/v1/workout/plan',
      );
      printResponse(response);
      if (response.statusCode == 200) {
        List allPlans = response.data['data'];
        if (allPlans.isNotEmpty) {
          allPlans[0] = WorkStatusModel.fromMap(
            Map<String, dynamic>.from(allPlans[0]),
          );
          for (int i = 1; i < allPlans.length; i++) {
            workStatus.add(
              WorkStatusModel.fromMap(Map<String, dynamic>.from(allPlans[i])),
            );
          }
          selectedCategory.value = 'Calories';
          selectedPoints.value = workStatus.value.first.calories ?? 0;
        }
      } else {
        workStatus.value = [WorkStatusModel()];
      }
    } catch (e) {
      log(e.toString(), name: 'Error');
    }

    log('try to get marathon info');
    try {
      // get marathon programs
      dio.Response response = await dioClient.dio.get(
        '/api/marathon/v1/marathon',
      );
      printResponse(response);
      if (response.statusCode == 200) {
        List marathonListData = response.data['data'];
        userBox.put('marathonList', jsonEncode(marathonListData));
        marathonList.clear();
        for (var marathon in marathonListData) {
          marathonList.add(MarathonModel.fromMap(marathon));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onInit() async {
    allInfo.value = AllInfoModel.fromJson(userBox.get('info'));
    // load Marathon program cache
    List marathonListData = jsonDecode(
      userBox.get('marathonList', defaultValue: '[]'),
    );

    for (var marathon in marathonListData) {
      marathonList.add(
        MarathonModel.fromMap(Map<String, dynamic>.from(marathon)),
      );
    }
    dataAsync();
    super.onInit();
  }
}
