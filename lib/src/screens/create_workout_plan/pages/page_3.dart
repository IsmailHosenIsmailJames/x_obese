import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/screens/controller/info_collector/model/all_info_model.dart';
import 'package:x_obese/src/screens/create_workout_plan/controller/create_workout_plan_controller.dart';
import 'package:x_obese/src/screens/create_workout_plan/model/create_workout_plan_model.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';

class CreateWorkoutPlanPage3 extends StatefulWidget {
  final PageController pageController;
  final bool update;
  final String? id;
  const CreateWorkoutPlanPage3({
    super.key,
    required this.pageController,
    required this.update,
    this.id,
  });

  @override
  State<CreateWorkoutPlanPage3> createState() => _CreateWorkoutPlanPage3State();
}

class _CreateWorkoutPlanPage3State extends State<CreateWorkoutPlanPage3> {
  final CreateWorkoutPlanController createWorkoutPlanController = Get.find();
  AllInfoController allInfoController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getBackButton(context, () {
                    Get.back();
                  }),
                  const Gap(55),
                  const Text(
                    'Plan Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Gap(22),
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                    () => workoutPlanOverview(
                      allInfoUser: allInfoController.allInfo.value,
                      startDate:
                          createWorkoutPlanController
                              .workOutPlan
                              .value
                              ?.startDate ??
                          DateTime.now(),
                      endDate:
                          createWorkoutPlanController
                              .workOutPlan
                              .value
                              ?.endDate ??
                          DateTime.now(),
                      userBMI:
                          createWorkoutPlanController.workOutPlan.value?.bmi ??
                          '',
                      goalType:
                          createWorkoutPlanController
                              .workOutPlan
                              .value
                              ?.goalType ??
                          '',
                      weightGoal:
                          (createWorkoutPlanController
                                      .workOutPlan
                                      .value
                                      ?.weightGoal ??
                                  '')
                              .toString(),
                      workoutDays:
                          createWorkoutPlanController
                              .workOutPlan
                              .value
                              ?.workoutDays ??
                          '',
                      workoutTimeMs:
                          createWorkoutPlanController
                              .workOutPlan
                              .value
                              ?.workoutTimeMs ??
                          '0',
                      calorieBairn:
                          (createWorkoutPlanController
                                  .workOutPlan
                                  .value
                                  ?.caloriesGoal ??
                              0),

                      daysTotal:
                          (createWorkoutPlanController
                                      .workOutPlan
                                      .value
                                      ?.totalDays ??
                                  '0')
                              .toString(),
                      context: context,
                      controller:
                          createWorkoutPlanController.createWorkoutPlanModel,
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget workoutPlanOverview({
  required BuildContext context,
  required AllInfoModel allInfoUser,
  required String userBMI,
  required DateTime startDate,
  required DateTime endDate,
  required String goalType,
  required String weightGoal,
  required String workoutDays,
  required String workoutTimeMs,
  required int calorieBairn,
  required String daysTotal,
  Rx<CreateWorkoutPlanModel>? controller,
}) {
  log(startDate.toString());
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Gap(10),

      const Text(
        'Generated For You',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xffD9D9D9),
        ),
      ),
      const Gap(6),
      Text(
        'Plan To ${goalType.replaceAll('_', ' ').capitalize}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: MyAppColors.third,
        ),
      ),
      Text(
        '${DateFormat.yMMMMd().format(startDate)} - ${DateFormat.yMMMMd().format(endDate)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: MyAppColors.mutedGray,
        ),
      ),

      const Gap(24),
      Container(
        height: 140,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'BMI: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  userBMI,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: MyAppColors.third,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Workout Goal: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  goalType.replaceAll('_', ' ').capitalize,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: MyAppColors.third,
                  ),
                ),
              ],
            ),
            if (double.tryParse(weightGoal) != null &&
                double.tryParse(weightGoal)! > 0)
              Row(
                children: [
                  const Text(
                    'Wight: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    weightGoal,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: MyAppColors.third,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      Container(
        height: 140,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            (workoutDays.split(',').length).toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: MyAppColors.third,
                            ),
                          ),
                          const Text(' Day'),
                        ],
                      ),
                      Text(
                        'Weekly',
                        style: TextStyle(
                          fontSize: 16,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Text(
                          '$daysTotal ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: MyAppColors.third,
                          ),
                        ),
                        const Text('Day'),
                      ],
                    ),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        color: MyAppColors.mutedGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Text(
                            '${(int.parse(workoutTimeMs) / 60000).toInt()} ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: MyAppColors.third,
                            ),
                          ),
                          const Text('Min'),
                        ],
                      ),
                      Text(
                        'Duration Time',
                        style: TextStyle(
                          fontSize: 16,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Text('${calorieBairn < 0 ? 'Lose' : 'Gain'} '),
                        Text(
                          '${calorieBairn.abs()} ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: MyAppColors.third,
                          ),
                        ),
                        const Text('Cal'),
                      ],
                    ),
                    Text(
                      'Consumption',
                      style: TextStyle(
                        fontSize: 16,
                        color: MyAppColors.mutedGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
