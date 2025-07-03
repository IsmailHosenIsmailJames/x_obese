import "dart:developer";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/create_workout_plan/controller/create_workout_plan_controller.dart";
import "package:x_obese/src/screens/create_workout_plan/model/create_workout_plan_model.dart";
import "package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:toastification/toastification.dart";

class CreateWorkoutPlanPage2 extends StatefulWidget {
  final PageController pageController;
  final bool update;
  final String? id;
  const CreateWorkoutPlanPage2({
    super.key,
    required this.pageController,
    required this.update,
    this.id,
  });

  @override
  State<CreateWorkoutPlanPage2> createState() => _CreateWorkoutPlanPage2State();
}

class _CreateWorkoutPlanPage2State extends State<CreateWorkoutPlanPage2> {
  List<String> selectedWeekDays = [];
  List<String> weekDays = ["Fri", "Sat", "Sun", "Mon", "Tue", "Wed", "Thu"];
  Map<String, String> mapOfWeekDays = {
    "Fri": "Friday",
    "Sat": "Saturday",
    "Sun": "Sunday",
    "Mon": "Monday",
    "Tue": "Tuesday",
    "Wed": "Wednesday",
    "Thu": "Thursday",
  };
  final CreateWorkoutPlanController createWorkoutPlanController = Get.find();
  @override
  void initState() {
    log(
      createWorkoutPlanController.createWorkoutPlanModel.value.workoutTimeMs ??
          "Not Found",
    );
    createWorkoutPlanController.createWorkoutPlanModel.value.activateReminder =
        true;
    createWorkoutPlanController.createWorkoutPlanModel.value.startDate ??=
        DateTime.now();
    createWorkoutPlanController
        .createWorkoutPlanModel
        .value
        .endDate ??= DateTime.now().add(const Duration(days: 365));
    createWorkoutPlanController.createWorkoutPlanModel.value.workoutTimeMs ??=
        "40";

    if (createWorkoutPlanController.createWorkoutPlanModel.value.workoutDays !=
        null) {
      String days =
          createWorkoutPlanController.createWorkoutPlanModel.value.workoutDays!;
      for (String day in days.split(",")) {
        selectedWeekDays.add(day.substring(0, 3));
      }
    }
    super.initState();
  }

  TimeOfDay reminderTime = const TimeOfDay(hour: 6, minute: 0);

  AllInfoController allInfoController = Get.find();

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
                    widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }),
                  const Gap(55),
                  const Text(
                    "Workout Goal",
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
                        "Daily Duration",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(16),
                      const Gap(5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${createWorkoutPlanController.createWorkoutPlanModel.value.workoutTimeMs} Min",
                        ),
                      ),
                      const Gap(10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: MyAppColors.third.withValues(
                            alpha: 0.7,
                          ),
                          padding: EdgeInsets.zero,
                          inactiveTrackColor: MyAppColors.transparentGray,
                          thumbColor: MyAppColors.third,
                          trackHeight: 12,
                        ),
                        child: Slider(
                          value:
                              int.parse(
                                createWorkoutPlanController
                                    .createWorkoutPlanModel
                                    .value
                                    .workoutTimeMs!,
                              ).toDouble(),
                          onChanged: (value) {
                            setState(() {
                              createWorkoutPlanController
                                  .createWorkoutPlanModel
                                  .value
                                  .workoutTimeMs = value.round().toString();
                            });
                          },
                          min: 0,
                          max: 90,
                          divisions: 90,
                        ),
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          Text(
                            "0 Min",
                            style: TextStyle(color: MyAppColors.mutedGray),
                          ),
                          const Spacer(),
                          Text(
                            "90 Min",
                            style: TextStyle(color: MyAppColors.mutedGray),
                          ),
                        ],
                      ),
                      const Gap(33),
                      const Text(
                        "Day For workout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(weekDays.length, (
                          index,
                        ) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedWeekDays.contains(
                                  weekDays[index],
                                )) {
                                  selectedWeekDays.remove(weekDays[index]);
                                } else {
                                  selectedWeekDays.add(weekDays[index]);
                                }
                                String workoutDaysString = "";
                                for (
                                  int i = 0;
                                  i < selectedWeekDays.length;
                                  i++
                                ) {
                                  if (i == selectedWeekDays.length - 1) {
                                    workoutDaysString +=
                                        mapOfWeekDays[selectedWeekDays[i]]!;
                                  } else {
                                    workoutDaysString +=
                                        "${mapOfWeekDays[selectedWeekDays[i]]!},";
                                  }
                                }
                                createWorkoutPlanController
                                    .createWorkoutPlanModel
                                    .value
                                    .workoutDays = workoutDaysString.substring(
                                  0,
                                  workoutDaysString.length,
                                );
                                setState(() {
                                  log(
                                    "Set -> ${createWorkoutPlanController.createWorkoutPlanModel.value.workoutDays}",
                                  );
                                });
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  selectedWeekDays.contains(weekDays[index])
                                      ? MyAppColors.third
                                      : MyAppColors.transparentGray,
                              child: Text(
                                weekDays[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      selectedWeekDays.contains(weekDays[index])
                                          ? MyAppColors.primary
                                          : MyAppColors.mutedGray,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const Gap(33),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Workout Day Reminder",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Switch(
                            value:
                                createWorkoutPlanController
                                    .createWorkoutPlanModel
                                    .value
                                    .activateReminder ??
                                false,
                            onChanged: (value) {
                              setState(() {
                                createWorkoutPlanController
                                    .createWorkoutPlanModel
                                    .value
                                    .activateReminder = value;
                              });
                            },
                            activeTrackColor: MyAppColors.third,
                            inactiveTrackColor: MyAppColors.transparentGray,
                          ),
                        ],
                      ),
                      const Gap(33),
                      Row(
                        children: [
                          const Text(
                            "Reminder",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              reminderTime =
                                  await showTimePicker(
                                    context: context,
                                    initialTime: reminderTime,
                                  ) ??
                                  reminderTime;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Text(
                                  reminderTime.format(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: MyAppColors.mutedGray,
                                  ),
                                ),
                                const Gap(10),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: MyAppColors.mutedGray,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(33),
                      Row(
                        children: [
                          const Text(
                            "Start Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              DateTime? start = await showDatePicker(
                                context: context,

                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                                initialDate:
                                    createWorkoutPlanController
                                        .createWorkoutPlanModel
                                        .value
                                        .startDate ??
                                    DateTime.now(),
                              );
                              setState(() {
                                if (start != null) {
                                  createWorkoutPlanController
                                      .createWorkoutPlanModel
                                      .value
                                      .startDate = start;
                                }
                                log(
                                  createWorkoutPlanController
                                      .createWorkoutPlanModel
                                      .value
                                      .startDate
                                      .toString(),
                                );
                              });
                            },
                            child: Text(
                              DateFormat.yMMMMd().format(
                                createWorkoutPlanController
                                        .createWorkoutPlanModel
                                        .value
                                        .startDate ??
                                    DateTime.now(),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: MyAppColors.mutedGray,
                              ),
                            ),
                          ),
                          const Gap(10),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyAppColors.mutedGray,
                            size: 16,
                          ),
                        ],
                      ),
                      const Gap(33),
                      Row(
                        children: [
                          const Text(
                            "End Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              DateTime? end = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                                initialDate:
                                    createWorkoutPlanController
                                        .createWorkoutPlanModel
                                        .value
                                        .endDate ??
                                    DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                              );
                              setState(() {
                                if (end != null) {
                                  createWorkoutPlanController
                                      .createWorkoutPlanModel
                                      .value
                                      .endDate = end;
                                }
                              });
                            },
                            child: Text(
                              DateFormat.yMMMMd().format(
                                createWorkoutPlanController
                                        .createWorkoutPlanModel
                                        .value
                                        .endDate ??
                                    DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: MyAppColors.mutedGray,
                              ),
                            ),
                          ),
                          const Gap(10),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyAppColors.mutedGray,
                            size: 16,
                          ),
                        ],
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
                    if (selectedWeekDays.isEmpty) {
                      toastification.show(
                        context: context,
                        title: const Text("Please select at least one day"),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                      return;
                    }
                    String workoutDaysString = "";
                    for (int i = 0; i < selectedWeekDays.length; i++) {
                      if (i == selectedWeekDays.length - 1) {
                        workoutDaysString +=
                            mapOfWeekDays[selectedWeekDays[i]]!;
                      } else {
                        workoutDaysString +=
                            "${mapOfWeekDays[selectedWeekDays[i]]!},";
                      }
                    }

                    createWorkoutPlanController
                        .createWorkoutPlanModel
                        .value
                        .workoutDays = workoutDaysString;

                    createWorkoutPlanController
                        .createWorkoutPlanModel
                        .value
                        .reminderTime = DateFormat("yyyy-MM-dd").format(
                      DateTime.now().copyWith(
                        hour: reminderTime.hour,
                        minute: reminderTime.minute,
                      ),
                    );

                    if (createWorkoutPlanController
                            .createWorkoutPlanModel
                            .value
                            .startDate!
                            .millisecondsSinceEpoch >
                        createWorkoutPlanController
                            .createWorkoutPlanModel
                            .value
                            .endDate!
                            .millisecondsSinceEpoch) {
                      toastification.show(
                        context: context,
                        title: const Text("Start and End date not valid"),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                      return;
                    }

                    await saveToAPI(context);
                    log(
                      createWorkoutPlanController.createWorkoutPlanModel.value
                          .toJson(),
                    );
                  },
                  child: const Text("Generate Plan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveToAPI(BuildContext context) async {
    CreateWorkoutPlanModel createWorkoutPlanModel =
        createWorkoutPlanController.createWorkoutPlanModel.value.copyWith();
    createWorkoutPlanModel.goalType = createWorkoutPlanModel.goalType!
        .toLowerCase()
        .replaceAll(" ", "_");

    createWorkoutPlanModel.workoutTimeMs =
        ((int.parse(createWorkoutPlanModel.workoutTimeMs ?? "0")) * 60000)
            .toString();

    log(createWorkoutPlanModel.toJson(), name: "Save Workout Plan Data");
    DioClient dioClient = DioClient(baseAPI);
    try {
      log(createWorkoutPlanModel.toJson(), name: "Save Workout Plan");
      final response =
          widget.update == true
              ? await dioClient.dio.patch(
                "/api/user/v1/workout/plan/${widget.id}",
                data: createWorkoutPlanModel.toMap(),
              )
              : await dioClient.dio.post(
                workoutPlanPath,
                data: createWorkoutPlanModel.toMap(),
              );
      printResponse(response);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final GetWorkoutPlans generatedWorkoutPlan = GetWorkoutPlans.fromMap(
          response.data["data"],
        );
        createWorkoutPlanController.workOutPlan.value = generatedWorkoutPlan;
        widget.pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        toastification.show(
          context: context,
          title: Text(response.data["message"]),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
        allInfoController.dataAsync();
      }
    } on DioException catch (e) {
      log(e.toString());
      if (e.response != null) {
        printResponse(e.response!);
        Fluttertoast.showToast(msg: e.response?.data["message"]);
      }
    }
  }
}
