import "dart:convert";
import "dart:developer";

import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/screens/controller/info_collector/model/all_info_model.dart";
import "package:dio/dio.dart" as dio;
import "package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/screens/resources/workout/status.dart";

class AllInfoController extends GetxController {
  RxDouble selectedPoints = 0.0.obs;
  RxString selectedCategory = "Calories".obs;
  RxInt stepsCount = 0.obs;

  static DioClient dioClient = DioClient(baseAPI);
  static Box userBox = Hive.box("user");

  Rx<AllInfoModel> allInfo = Rx<AllInfoModel>(AllInfoModel());
  Rx<WorkStatusModel> workStatus = Rx<WorkStatusModel>(WorkStatusModel());
  RxList<MarathonModel> marathonList = RxList<MarathonModel>([]);
  RxList<GetWorkoutPlans> getWorkoutPlansList =
      (<GetWorkoutPlans>[GetWorkoutPlans(id: "init")]).obs;
  RxList<GetBlogModel> getBlogList = RxList<GetBlogModel>([]);

  Future<dio.Response?> updateUserInfo(dio.FormData data) async {
    try {
      DioClient dioClient = DioClient(baseAPI);
      final response = await dioClient.dio.patch(userDataPath, data: data);
      printResponse(response);
      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } on dio.DioException catch (e) {
      log(e.message.toString());
      if (e.response != null) printResponse(e.response!);
      return null;
    }
  }

  Future<void> dataAsync() async {
    // get workout plan
    log("Try get workout plan", name: "Try get workout plan");
    try {
      DioClient dioClient = DioClient(baseAPI);
      dio.Response response = await dioClient.dio.get(
        "$getUserWorkoutStatus?view=weekly",
      );
      printResponse(response);
      if (response.statusCode == 200) {
        Map? status = response.data["data"];
        if (status != null) {
          final statusModel = WorkStatusModel.fromMap(
            Map<String, dynamic>.from(status),
          );

          workStatus.value = statusModel.copyWith(
            durationMs: (statusModel.durationMs ?? 0) / 60000,
          );

          selectedCategory.value = "Calories";
          selectedPoints.value = double.parse(workStatus.value.calories ?? "0");
        }
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "", name: "Error");
      if (e.response != null) {
        printResponse(e.response!);
      }
    }

    log("try to get marathon info");
    try {
      // get marathon programs
      dio.Response response = await dioClient.dio.get(
        "/api/marathon/v1/marathon",
      );
      if (response.statusCode == 200) {
        List marathonListData = response.data["data"];
        userBox.put(
          "marathonList",
          const JsonEncoder.withIndent(" ").convert(marathonListData),
        );
        marathonList.clear();
        for (var marathon in marathonListData) {
          marathonList.add(MarathonModel.fromMap(marathon));
        }
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "", name: "Error");
      if (e.response != null) {
        printResponse(e.response!);
      }
    }
    try {
      dio.Response response = await dioClient.dio.get(workoutPlanPath);
      printResponse(response);
      if (response.statusCode == 200) {
        log(
          const JsonEncoder.withIndent("   ").convert(response.data),
          name: "dioClient.dio.get(workoutPlanPath)",
        );
        List workoutPlans = response.data["data"];
        if (workoutPlans.isNotEmpty) {
          getWorkoutPlansList.value = [GetWorkoutPlans(id: "init")];
          for (var workoutPlan in workoutPlans) {
            getWorkoutPlansList.add(GetWorkoutPlans.fromMap(workoutPlan));
          }
          getWorkoutPlansList.removeAt(0);
        }

        printResponse(response);
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "", name: "Error");
      if (e.response != null) {
        printResponse(e.response!);
      }
    }
    try {
      dio.Response response = await dioClient.dio.get(blogPath);
      if (response.statusCode == 200) {
        List blogList = response.data["data"] ?? [];
        getBlogList.value = [GetBlogModel()];
        for (var blog in blogList) {
          getBlogList.add(GetBlogModel.fromMap(blog));
        }
        getBlogList.removeAt(0);
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "", name: "Error");
      if (e.response != null) {
        printResponse(e.response!);
      }
    }
  }

  @override
  void onInit() async {
    allInfo.value = AllInfoModel.fromJson(userBox.get("info"));
    // load Marathon program cache
    List marathonListData = jsonDecode(
      userBox.get("marathonList", defaultValue: "[]"),
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
