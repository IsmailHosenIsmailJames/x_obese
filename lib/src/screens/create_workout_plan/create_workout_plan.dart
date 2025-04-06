import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/screens/create_workout_plan/controller/create_workout_plan_controller.dart';
import 'package:x_obese/src/screens/create_workout_plan/pages/page_1.dart';
import 'package:x_obese/src/screens/create_workout_plan/pages/page_2.dart';
import 'package:x_obese/src/screens/create_workout_plan/pages/page_3.dart';

class CreateWorkoutPlan extends StatefulWidget {
  const CreateWorkoutPlan({super.key});

  @override
  State<CreateWorkoutPlan> createState() => _CreateWorkoutPlanState();
}

class _CreateWorkoutPlanState extends State<CreateWorkoutPlan> {
  PageController pageController = PageController();
  final CreateWorkoutPlanController createWorkoutPlanController = Get.put(
    CreateWorkoutPlanController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CreateWorkoutPlanPage1(pageController: pageController),
          CreateWorkoutPlanPage2(pageController: pageController),
          CreateWorkoutPlanPage3(pageController: pageController),
        ],
      ),
    );
  }
}
