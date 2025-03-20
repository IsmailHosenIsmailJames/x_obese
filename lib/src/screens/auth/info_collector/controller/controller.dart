import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';
import 'package:o_xbese/src/screens/auth/controller/auth_controller.dart';
import 'package:o_xbese/src/screens/auth/info_collector/model/all_info_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:o_xbese/src/screens/resources/workout/status.dart';

class AllInfoController extends GetxController {
  RxInt selectedPoints = 0.obs;
  RxString selectedCategory = 'Calories'.obs;

  static DioClient dioClient = DioClient(baseAPI);
  static Box userBox = Hive.box('user');

  Rx<AllInfoModel> allInfo = Rx<AllInfoModel>(AllInfoModel());
  Rx<WorkStatusModel> workStatus = Rx<WorkStatusModel>(WorkStatusModel());

  Future<dio.Response?> updateUserInfo(dynamic data) async {
    final response = await dioClient.patch(userDataPath, data: data);
    printResponse(response);
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }

  Future<void> dataAsync() async {
    // get workout plan
    DioClient dioClient = DioClient(baseAPI);
    dio.Response response = await dioClient.get(getUserWorkStatusPath);
    printResponse(response);
    if (response.statusCode == 200) {
      workStatus.value = WorkStatusModel.fromMap(
        Map<String, dynamic>.from(response.data['data']),
      );
      selectedCategory.value = 'Calories';
      selectedPoints.value = workStatus.value.calories ?? 0;
    } else {
      workStatus.value = WorkStatusModel();
    }
  }

  @override
  void onInit() {
    allInfo.value = AllInfoModel.fromJson(userBox.get('info'));
    dataAsync();
    super.onInit();
  }
}
