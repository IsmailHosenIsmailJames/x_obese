import "dart:convert";
import "dart:developer";

import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/core/health/my_health_functions.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";
import "package:dio/dio.dart" as dio;
import "package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/screens/resources/workout/status.dart";

class AllInfoController extends GetxController {
  RxDouble selectedPoints = 0.0.obs;
  RxString selectedCategory = "Calories".obs;
  RxInt stepsCount = 0.obs;

  static final DioClient _dioClient = DioClient(baseAPI);
  static final Box _userBox = Hive.box("user");

  Rx<UserInfoModel> allInfo = Rx<UserInfoModel>(UserInfoModel());
  Rx<WorkStatusModel?> workStatus = Rx<WorkStatusModel?>(null);
  Rx<List<MarathonModel>?> marathonList = Rx<List<MarathonModel>?>(null);
  Rx<List<GetWorkoutPlans>?> getWorkoutPlansList = Rx<List<GetWorkoutPlans>?>(
    null,
  );
  Rx<List<GetBlogModel>?> getBlogList = Rx<List<GetBlogModel>?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadDataFromCache();
    dataAsync();
  }

  Future<bool> updateUserInfo(dio.FormData data) async {
    try {
      final response = await _dioClient.dio.patch(userDataPath, data: data);
      if (response.statusCode == 200) {
        final newInfo = UserInfoModel.fromMap(response.data["data"]);
        allInfo.value = newInfo;
        _userBox.put("info", newInfo.toJson());
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      log(e.message.toString(), name: "updateUserInfo");
      if (e.response != null) printResponse(e.response!);
      return false;
    }
  }

  Future<void> dataAsync() async {
    await Future.wait([
      _fetchWorkoutStatus(),
      _fetchMarathonPrograms(),
      _fetchWorkoutPlans(),
      _fetchBlogs(),
    ]);
  }

  void _loadDataFromCache() {
    // Load user info
    final infoJson = _userBox.get("info");
    if (infoJson != null) {
      log(infoJson, name: "User Info");
      allInfo.value = UserInfoModel.fromJson(infoJson);
    }

    // Load marathon list
    final marathonListJson = _userBox.get("marathonList", defaultValue: "[]");
    final List marathonListData = jsonDecode(marathonListJson);
    marathonList.value =
        marathonListData
            .map(
              (data) => MarathonModel.fromMap(Map<String, dynamic>.from(data)),
            )
            .toList();

    // Load workout plans
    final workoutPlansJson = _userBox.get("workoutPlans", defaultValue: "[]");
    final List workoutPlansData = jsonDecode(workoutPlansJson);
    getWorkoutPlansList.value =
        workoutPlansData
            .map(
              (data) =>
                  GetWorkoutPlans.fromMap(Map<String, dynamic>.from(data)),
            )
            .toList();

    // Load blogs
    final blogListJson = _userBox.get("blogList", defaultValue: "[]");
    final List blogListData = jsonDecode(blogListJson);
    getBlogList.value =
        blogListData
            .map(
              (data) => GetBlogModel.fromMap(Map<String, dynamic>.from(data)),
            )
            .toList();
  }

  Future<void> _fetchWorkoutStatus() async {
    UserInfoModel? userInfoModel = UserDB.userAllInfo();
    if (userInfoModel?.isGuest ?? true) {
      log("Guest has no Workout Status save. User demo");
      final status = WorkStatusModel(
        heartPts: "0",
        distanceKm: "0",
        calories: "0",
        steps: await MyHealthFunctions.fetchSteps(
          DateTime.now().copyWith(hour: 0, minute: 0, second: 0),
          DateTime.now(),
        ),
      );
      workStatus.value = status.copyWith(
        durationMs: (status.durationMs ?? 0) / 60000,
        steps: status.steps ?? 0,
      );
      return;
    }
    try {
      final response = await _dioClient.dio.get(
        "$getUserWorkoutStatus?view=weekly",
      );
      if (response.statusCode == 200 && response.data["data"] != null) {
        final status = WorkStatusModel.fromMap(
          Map<String, dynamic>.from(response.data["data"]),
        );
        workStatus.value = status.copyWith(
          durationMs: (status.durationMs ?? 0) / 60000,
        );
        selectedCategory.value = "Calories";
        selectedPoints.value = double.parse(workStatus.value?.calories ?? "0");
      }
    } on dio.DioException catch (e) {
      log(
        "Failed to fetch workout status: ${e.message}",
        name: "_fetchWorkoutStatus",
      );
    }
  }

  Future<void> _fetchMarathonPrograms() async {
    try {
      final response = await _dioClient.dio.get("/api/marathon/v1/marathon");
      if (response.statusCode == 200) {
        final List marathonListData = response.data["data"];
        _userBox.put("marathonList", jsonEncode(marathonListData));
        marathonList.value =
            marathonListData
                .map((data) => MarathonModel.fromMap(data))
                .toList();
      }
    } on dio.DioException catch (e) {
      log(
        "Failed to fetch marathon programs: ${e.message}",
        name: "_fetchMarathonPrograms",
      );
    }
  }

  Future<void> _fetchWorkoutPlans() async {
    UserInfoModel? userInfoModel = UserDB.userAllInfo();
    if (userInfoModel?.isGuest ?? true) {
      log("Guest has no Workout Plans");
      return;
    }
    try {
      final response = await _dioClient.dio.get(workoutPlanPath);
      if (response.statusCode == 200) {
        final List workoutPlans = response.data["data"];
        _userBox.put("workoutPlans", jsonEncode(workoutPlans));
        getWorkoutPlansList.value =
            workoutPlans.map((data) => GetWorkoutPlans.fromMap(data)).toList();
      }
    } on dio.DioException catch (e) {
      log("Failed to fetch workout plans: ${e.message}");
    }
  }

  Future<void> _fetchBlogs() async {
    try {
      final response = await _dioClient.dio.get(blogPath);
      if (response.statusCode == 200) {
        final List blogList = response.data["data"] ?? [];
        _userBox.put("blogList", jsonEncode(blogList));
        getBlogList.value =
            blogList.map((data) => GetBlogModel.fromMap(data)).toList();
      }
    } on dio.DioException catch (e) {
      log("Failed to fetch blogs: ${e.message}");
    }
  }
}
