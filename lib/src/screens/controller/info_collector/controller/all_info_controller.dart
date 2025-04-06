import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';
import 'package:o_xbese/src/screens/blog/model/get_blog_model.dart';
import 'package:o_xbese/src/screens/controller/info_collector/model/all_info_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:o_xbese/src/screens/create_workout_plan/model/get_workout_plans.dart';
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
  RxList<GetWorkoutPlans> getWorkoutPlansList =
      (<GetWorkoutPlans>[GetWorkoutPlans()]).obs;
  RxList<GetBlogModel> getBlogList = RxList<GetBlogModel>([]);

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
    } on dio.DioException catch (e) {
      log(e.message ?? '', name: 'Error');
      if (e.response != null) {
        printResponse(e.response!);
      }
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
    } on dio.DioException catch (e) {
      log(e.message ?? '', name: 'Error');
      if (e.response != null) {
        printResponse(e.response!);
      }
    }
    try {
      // get marathon programs
      dio.Response response = await dioClient.dio.get(workoutPlanPath);
      printResponse(response);
      if (response.statusCode == 200) {
        List workoutPlans = response.data['data'];
        getWorkoutPlansList.value = [GetWorkoutPlans()];
        for (var workoutPlan in workoutPlans) {
          getWorkoutPlansList.add(GetWorkoutPlans.fromMap(workoutPlan));
        }
        getWorkoutPlansList.removeAt(0);

        printResponse(response);
      }
    } on dio.DioException catch (e) {
      log(e.message ?? '', name: 'Error');
      if (e.response != null) {
        printResponse(e.response!);
      }
    }
    try {
      // get marathon programs
      dio.Response response = await dioClient.dio.get(blogPath);
      printResponse(response);
      if (response.statusCode == 200) {
        List blogList = response.data['data'];
        getBlogList.value = [GetBlogModel()];
        for (var blog in blogList) {
          getBlogList.add(GetBlogModel.fromMap(blog));
        }
        getBlogList.removeAt(0);
        printResponse(response);
      }
    } on dio.DioException catch (e) {
      log(e.message ?? '', name: 'Error');
      if (e.response != null) {
        printResponse(e.response!);
      }
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
