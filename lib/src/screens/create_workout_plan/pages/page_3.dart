import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:x_obese/src/apis/apis_url.dart';
import 'package:x_obese/src/apis/middleware/jwt_middleware.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/screens/controller/info_collector/model/all_info_model.dart';
import 'package:x_obese/src/screens/create_workout_plan/controller/create_workout_plan_controller.dart';
import 'package:x_obese/src/screens/create_workout_plan/model/create_workout_plan_model.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';
import 'package:toastification/toastification.dart';

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
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 365));
    createWorkoutPlanController.createWorkoutPlanModel.value.startDate =
        startDate;
    createWorkoutPlanController.createWorkoutPlanModel.value.endDate = endDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(
      widget.update == true
          ? '/api/user/v1/workout/plan/${widget.id}'
          : workoutPlanPath,
    );
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
                    widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }),
                  const Gap(55),
                  const Text(
                    'Plan Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Gap(22),
              Obx(
                () => Expanded(
                  child: SingleChildScrollView(
                    child: workoutPlanOverview(
                      allInfoUser: allInfoController.allInfo.value,
                      startDate:
                          createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .startDate ??
                          DateTime.now(),
                      endDate:
                          createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .endDate ??
                          DateTime.now(),
                      userBMI: createWorkoutPlanController.userBMI.toString(),
                      goalType:
                          createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .goalType ??
                          '',
                      weightGoal:
                          createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .weightGoal ??
                          '',
                      workoutDays:
                          createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .workoutDays ??
                          '',
                      workoutTime:
                          createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .workoutTime ??
                          '',
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
                  onPressed: () async {
                    await saveToAPI(context);
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

  Future<void> saveToAPI(BuildContext context) async {
    createWorkoutPlanController
        .createWorkoutPlanModel
        .value
        .goalType = createWorkoutPlanController
        .createWorkoutPlanModel
        .value
        .goalType!
        .toLowerCase()
        .replaceAll(' ', '_');

    createWorkoutPlanController.createWorkoutPlanModel.value.workoutTime =
        ((int.parse(
                  createWorkoutPlanController
                          .createWorkoutPlanModel
                          .value
                          .workoutTime ??
                      '0',
                )) *
                60000)
            .toString();

    log(createWorkoutPlanController.createWorkoutPlanModel.value.toJson());
    DioClient dioClient = DioClient(baseAPI);
    try {
      final response =
          widget.update == true
              ? await dioClient.dio.patch(
                '/api/user/v1/workout/plan/${widget.id}',
                data:
                    createWorkoutPlanController.createWorkoutPlanModel.value
                        .toMap(),
              )
              : await dioClient.dio.post(
                workoutPlanPath,
                data:
                    createWorkoutPlanController.createWorkoutPlanModel.value
                        .toMap(),
              );
      printResponse(response);
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        toastification.show(
          context: context,
          title: Text(response.data['message']),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } on DioException catch (e) {
      log(e.toString());
      if (e.response != null) {
        printResponse(e.response!);
        Fluttertoast.showToast(msg: e.response?.data['message']);
      }
    }
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
  required String workoutTime,
  Rx<CreateWorkoutPlanModel>? controller,
}) {
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
      Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (controller == null) return;
              DateTime? date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
              );

              controller.value = controller.value.copyWith(startDate: date);
            },
            child: Text(
              DateFormat('yyyy-MM-dd').format(startDate),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MyAppColors.mutedGray,
              ),
            ),
          ),
          Text(
            ' - ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MyAppColors.mutedGray,
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (controller == null) return;
              DateTime? date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
              );

              controller.value = controller.value.copyWith(endDate: date);
            },
            child: Text(
              DateFormat('yyyy-MM-dd').format(endDate),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MyAppColors.mutedGray,
              ),
            ),
          ),
        ],
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
                            (workoutDays.split(',').length + 1).toString(),
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
                          '100 ',
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
                            '$workoutTime ',
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
                        Text(
                          '300 ',
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
