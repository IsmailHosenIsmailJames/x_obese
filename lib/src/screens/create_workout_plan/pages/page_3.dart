import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';
import 'package:o_xbese/src/screens/create_workout_plan/controller/create_workout_plan_controller.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:o_xbese/src/widgets/back_button.dart';
import 'package:toastification/toastification.dart';

class CreateWorkoutPlanPage3 extends StatefulWidget {
  final PageController pageController;
  const CreateWorkoutPlanPage3({super.key, required this.pageController});

  @override
  State<CreateWorkoutPlanPage3> createState() => _CreateWorkoutPlanPage3State();
}

class _CreateWorkoutPlanPage3State extends State<CreateWorkoutPlanPage3> {
  final CreateWorkoutPlanController createWorkoutPlanController = Get.find();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 365));

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
                  getBackbutton(context, () {
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                        'Plan To ${createWorkoutPlanController.createWorkoutPlanModel.value.goalType}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: MyAppColors.third,
                        ),
                      ),
                      Text(
                        '${DateFormat('yyyy-MM-dd').format(startDate)} - ${DateFormat('yyyy-MM-dd').format(endDate)}',
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
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'BMI: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  createWorkoutPlanController.userBMI.value
                                      .toString(),
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
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  createWorkoutPlanController
                                          .createWorkoutPlanModel
                                          .value
                                          .goalType ??
                                      '',
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
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  createWorkoutPlanController
                                          .createWorkoutPlanModel
                                          .value
                                          .weightGoal ??
                                      '',
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
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            (createWorkoutPlanController
                                                        .createWorkoutPlanModel
                                                        .value
                                                        .workoutDays!
                                                        .split(',')
                                                        .length +
                                                    1)
                                                .toString(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${createWorkoutPlanController.createWorkoutPlanModel.value.workoutTime} ',
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
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    createWorkoutPlanController
                        .createWorkoutPlanModel
                        .value
                        .startDate = startDate;
                    createWorkoutPlanController
                        .createWorkoutPlanModel
                        .value
                        .endDate = endDate;

                    createWorkoutPlanController
                        .createWorkoutPlanModel
                        .value
                        .goalType = createWorkoutPlanController
                        .createWorkoutPlanModel
                        .value
                        .goalType!
                        .toLowerCase()
                        .replaceAll(' ', '_');

                    log(
                      createWorkoutPlanController.createWorkoutPlanModel.value
                          .toJson(),
                    );
                    DioClient dioClient = DioClient(baseAPI);
                    try {
                      final response = await dioClient.dio.post(
                        workoutPlanPath,
                        data:
                            createWorkoutPlanController
                                .createWorkoutPlanModel
                                .value
                                .toJson(),
                      );
                      printResponse(response);
                      if (response.statusCode == 201 ||
                          response.statusCode == 200) {
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
                      printResponse(e.response!);
                    }
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
