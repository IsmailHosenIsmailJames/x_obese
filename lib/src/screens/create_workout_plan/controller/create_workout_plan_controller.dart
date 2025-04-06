import 'package:get/get.dart';
import 'package:x_obese/src/screens/create_workout_plan/model/create_workout_plan_model.dart';

class CreateWorkoutPlanController extends GetxController {
  Rx<CreateWorkoutPlanModel> createWorkoutPlanModel =
      Rx<CreateWorkoutPlanModel>(CreateWorkoutPlanModel());
  RxDouble userBMI = RxDouble(0.0);
}
