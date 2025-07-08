import "dart:developer";

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:hive_flutter/adapters.dart";
import "package:intl/intl.dart";
import "package:x_obese/helth.dart";
import "package:x_obese/src/resources/svg_string.dart";
import "package:x_obese/src/screens/blog/blog_list_view.dart";
import "package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/create_workout_plan/create_workout_plan.dart";
import "package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart";
import "package:x_obese/src/screens/marathon/components/virtual_marathon_cards.dart";
import "package:x_obese/src/screens/marathon/marathon_page.dart";
import "package:x_obese/src/screens/settings/personal_details_view.dart";
import "package:x_obese/src/screens/workout_plan_overview/workout_plan_overview_screen.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/get_blog_card.dart";
import "package:x_obese/src/widgets/points_overview_widget.dart";

class HomePage extends StatefulWidget {
  final PageController pageController;
  const HomePage({super.key, required this.pageController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userBox = Hive.box("user");
  AllInfoController allInfoController = Get.find();
  ScrollController scrollControllerMarathon = ScrollController();
  ScrollController scrollControllerBlog = ScrollController();
  bool isBlogLoading = false;
  bool isMarathonLoading = false;
  @override
  void initState() {
    scrollControllerMarathon.addListener(() async {
      if (scrollControllerMarathon.position.pixels ==
          scrollControllerMarathon.position.maxScrollExtent) {
        setState(() {
          isMarathonLoading = true;
        });
        await getMoreMarathonData();
        setState(() {
          isMarathonLoading = false;
        });
      }
    });
    scrollControllerBlog.addListener(() async {
      if (scrollControllerBlog.position.pixels ==
          scrollControllerBlog.position.maxScrollExtent) {
        setState(() {
          isBlogLoading = true;
        });
        await getMoreBlogData();
        setState(() {
          isBlogLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(
      allInfoController.allInfo.value.image.toString(),
      name: "allInfoController.allInfo.value.image",
    );
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.pageController.jumpToPage(3);
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: MyAppColors.transparentGray,
                            child:
                                allInfoController.allInfo.value.image == null
                                    ? const Icon(Icons.person, size: 18)
                                    : CachedNetworkImage(
                                      imageUrl:
                                          allInfoController
                                              .allInfo
                                              .value
                                              .image!,
                                      alignment: Alignment.topCenter,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return Icon(
                                          Icons.broken_image,
                                          color: MyAppColors.mutedGray,
                                          size: 18,
                                        );
                                      },
                                    ),
                          ),
                        ),
                        const Gap(8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello 👋",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Obx(
                              () => Text(
                                allInfoController.allInfo.value.fullName ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: MyAppColors.mutedGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      Get.to(() => const HealthApp());
                    },
                    icon: SvgPicture.string(notificationSvg),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: pointsOverviewWidget(context, allInfoController),
            ),
            const Gap(20),
            Obx(() {
              if (allInfoController.getWorkoutPlansList.isEmpty ||
                  allInfoController.getWorkoutPlansList.first.id == "init") {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: MyAppColors.transparentGray,
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.string(workoutPlanIconSvgBlue),
                          ),
                        ),
                        const Gap(12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Workout Plan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(4),
                            SizedBox(
                              width: 180,
                              child: Text(
                                "Create Your Workout plan",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: MyAppColors.mutedGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 85,
                          height: 32,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => const CreateWorkoutPlan());
                            },
                            child: const Text("Create"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (allInfoController.getWorkoutPlansList.isNotEmpty &&
                  allInfoController.getWorkoutPlansList.first.id != null) {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => WorkoutPlanOverviewScreen(
                        getWorkoutPlansList:
                            allInfoController.getWorkoutPlansList,
                      ),
                    );
                  },
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Workout Plan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Gap(10),
                              if (allInfoController
                                          .getWorkoutPlansList
                                          .value
                                          .first
                                          .startDate !=
                                      null &&
                                  allInfoController
                                          .getWorkoutPlansList
                                          .value
                                          .first
                                          .endDate !=
                                      null)
                                Text(
                                  "${getWeekStatus(allInfoController.getWorkoutPlansList.value.first)} Weeks",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: MyAppColors.third,
                                  ),
                                ),
                              const Spacer(),
                              arrowIcon,
                            ],
                          ),
                          const Gap(10),
                          Container(
                            height: 100,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MyAppColors.transparentGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(weekdays.length, (
                                    index,
                                  ) {
                                    String day = DateFormat(
                                      DateFormat.WEEKDAY,
                                    ).format(DateTime.now());
                                    bool isSelected =
                                        weekdays.indexOf(day) == index;

                                    DateTime thisDay = DateTime.now().add(
                                      Duration(
                                        days: index - weekdays.indexOf(day),
                                      ),
                                    );

                                    return Container(
                                      width: 32,
                                      height: 44,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? MyAppColors.third
                                                : null,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: FittedBox(
                                        child: Column(
                                          children: [
                                            Text(
                                              weekdays[index]
                                                  .substring(0, 3)
                                                  .capitalizeFirst,
                                              style: TextStyle(
                                                color:
                                                    isSelected
                                                        ? Colors.white
                                                        : null,
                                              ),
                                            ),
                                            Text(
                                              (thisDay.day).toString(),
                                              style: TextStyle(
                                                color:
                                                    isSelected
                                                        ? Colors.white
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                Divider(
                                  color: MyAppColors.third.withValues(
                                    alpha: 0.2,
                                  ),
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(weekdays.length, (
                                    index,
                                  ) {
                                    String day = DateFormat(
                                      DateFormat.WEEKDAY,
                                    ).format(DateTime.now());

                                    DateTime thisDay = DateTime.now().add(
                                      Duration(
                                        days: index - weekdays.indexOf(day),
                                      ),
                                    );

                                    bool isSelected = haveWorkoutDay(
                                      allInfoController
                                          .getWorkoutPlansList
                                          .value
                                          .first,
                                      thisDay,
                                    );
                                    return SizedBox(
                                      width: 32,

                                      child:
                                          isSelected
                                              ? Center(
                                                child: CircleAvatar(
                                                  radius: 3,
                                                  backgroundColor:
                                                      MyAppColors.second,
                                                ),
                                              )
                                              : null,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Text("Something Found Wrong");
              }
            }),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Marathon Program",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.pageController.jumpToPage(2);
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(color: MyAppColors.third),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 220,
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollControllerMarathon,
                        scrollDirection: Axis.horizontal,
                        itemCount: allInfoController.marathonList.length,
                        padding: const EdgeInsets.only(right: 15),
                        itemBuilder: (context, index) {
                          return getMarathonCard(
                            context: context,
                            marathonData: allInfoController.marathonList[index],
                            margin: const EdgeInsets.only(left: 15),
                          );
                        },
                      ),
                    ),
                    if (isMarathonLoading) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Our Blogs & Tips",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const BlogListView());
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(color: MyAppColors.third),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 210,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        controller: scrollControllerBlog,
                        children: List.generate(
                          allInfoController.getBlogList.length,
                          (index) {
                            return getBlogCard(
                              context,
                              allInfoController.getBlogList[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool haveWorkoutDay(GetWorkoutPlans first, DateTime day) {
    List<String> weekdays = first.workoutDays?.split(",") ?? [];
    if (!(first.startDate != null &&
            first.endDate != null &&
            day.isAfter(first.startDate!) &&
            day.isBefore(first.endDate!)) &&
        !(isSameDate(first.endDate, day) || isSameDate(first.startDate, day))) {
      return false;
    }
    return weekdays.contains(DateFormat(DateFormat.WEEKDAY).format(day));
  }

  String getWeekStatus(GetWorkoutPlans plan) {
    DateTime start = plan.startDate!;
    DateTime end = plan.endDate!;
    int totalDays = start.difference(end).inDays.abs();
    int currentDays = start.difference(DateTime.now()).inDays.abs() + 1;
    if (totalDays < currentDays) currentDays = totalDays;
    return "${(currentDays / 7).ceil()}/${(totalDays / 7).ceil()}";
  }
}

List<String> weekdays = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
];
