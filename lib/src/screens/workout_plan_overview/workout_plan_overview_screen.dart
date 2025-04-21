import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/screens/create_workout_plan/create_workout_plan.dart';
import 'package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart';
import 'package:x_obese/src/screens/create_workout_plan/pages/page_3.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';

class WorkoutPlanOverviewScreen extends StatefulWidget {
  final List<GetWorkoutPlans> getWorkoutPlansList;
  const WorkoutPlanOverviewScreen({
    super.key,
    required this.getWorkoutPlansList,
  });

  @override
  State<WorkoutPlanOverviewScreen> createState() =>
      _WorkoutPlanOverviewScreenState();
}

class _WorkoutPlanOverviewScreenState extends State<WorkoutPlanOverviewScreen> {
  AllInfoController allInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
              child: Row(
                children: [
                  getBackbutton(context, () => Get.back()),
                  const Spacer(),
                  const Text(
                    'Marathon Program',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  workoutPlanOverview(
                    allInfoUser: allInfoController.allInfo.value,
                    userBMI: widget.getWorkoutPlansList.first.bmi ?? '',
                    startDate:
                        widget.getWorkoutPlansList.first.startDate ??
                        DateTime.now(),
                    endDate:
                        widget.getWorkoutPlansList.first.endDate ??
                        DateTime.now(),
                    goalType:
                        (widget.getWorkoutPlansList.first.goalType ?? 'None')
                            .replaceAll('_', ' ')
                            .capitalizeFirst,
                    weightGoal:
                        widget.getWorkoutPlansList.first.weightGoal
                            ?.toString() ??
                        '0',
                    workoutDays:
                        widget.getWorkoutPlansList.first.workoutDays ?? '',
                    workoutTime:
                        widget.getWorkoutPlansList.first.workoutTimeMs
                            ?.toString() ??
                        '0',
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                  ),
                  const Gap(30),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyAppColors.transparentGray,
                            ),
                            onPressed: () {
                              Get.to(() => const CreateWorkoutPlan());
                            },
                            child: Text(
                              'Create Plan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: MyAppColors.third,
                              ),
                            ),
                          ),
                        ),
                        const Gap(25),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'Adjust Plan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
