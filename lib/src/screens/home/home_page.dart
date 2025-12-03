import "dart:convert";
import "dart:developer";

import "package:cached_network_image/cached_network_image.dart";
import "package:dio/dio.dart" as dio;
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:hive_flutter/adapters.dart";
import "package:intl/intl.dart";
import "package:shimmer/shimmer.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/resources/svg_string.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/screens/blog/blog_list_view.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/screens/create_workout_plan/create_workout_plan.dart";
import "package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";
import "package:x_obese/src/screens/marathon/components/virtual_marathon_cards.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/screens/navs/naves_page.dart";
import "package:x_obese/src/screens/workout_plan_overview/workout_plan_overview_screen.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/banners/banners.dart";
import "package:x_obese/src/widgets/get_blog_card.dart";
import "package:x_obese/src/widgets/points_overview_widget.dart";
import "package:x_obese/src/widgets/popup_for_signup.dart";

mixin PaginationController<T extends StatefulWidget> on State<T> {
  void addPaginationListener({
    required ScrollController controller,
    required Future<void> Function() onFetch,
    required ValueGetter<bool> isLoading,
    required ValueSetter<bool> setLoading,
    double threshold = 0.9,
  }) {
    controller.addListener(() async {
      if (controller.position.hasContentDimensions &&
          !isLoading() &&
          controller.position.pixels >=
              controller.position.maxScrollExtent * threshold) {
        if (!mounted) return;
        setLoading(true);
        try {
          await onFetch();
        } finally {
          if (mounted) {
            setLoading(false);
          }
        }
      }
    });
  }
}

class HomePage extends StatefulWidget {
  final PageController pageController;

  const HomePage({super.key, required this.pageController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with PaginationController<HomePage> {
  final userBox = Hive.box("user");
  AllInfoController allInfoController = Get.find();
  ScrollController scrollControllerMarathon = ScrollController();
  ScrollController scrollControllerBlog = ScrollController();
  bool isBlogLoading = false;
  bool isMarathonLoading = false;
  final DioClient dioClient = DioClient(baseAPI);

  @override
  void initState() {
    super.initState();
    addPaginationListener(
      controller: scrollControllerMarathon,
      onFetch: getMoreMarathonData,
      isLoading: () => isMarathonLoading,
      setLoading: (loading) => setState(() => isMarathonLoading = loading),
    );
    addPaginationListener(
      controller: scrollControllerBlog,
      onFetch: getMoreBlogData,
      isLoading: () => isBlogLoading,
      setLoading: (loading) => setState(() => isBlogLoading = loading),
    );
  }

  @override
  void dispose() {
    scrollControllerMarathon.dispose();
    scrollControllerBlog.dispose();
    super.dispose();
  }

  bool isThereIsNoMoreMarathon = false;

  bool isThereIsNoMoreBlog = false;

  Future<void> getMoreMarathonData() async {
    if (isThereIsNoMoreMarathon) return;
    try {
      // get marathon programs
      dio.Response response = await dioClient.dio.get(
        "/api/marathon/v1/marathon?page=${((allInfoController.marathonList.value?.length ?? 0) / 10).ceil() + 1}",
      );
      printResponse(response);
      if (response.statusCode == 200) {
        List marathonListData = response.data["data"];
        userBox.put(
          "marathonList",
          const JsonEncoder.withIndent(" ").convert(marathonListData),
        );
        final newMarathons =
            marathonListData
                .map((data) => MarathonModel.fromMap(data))
                .toList();
        allInfoController.marathonList.value = [
          ...allInfoController.marathonList.value ?? [],
          ...newMarathons,
        ];
        if (isThereIsNoMoreMarathon == false && marathonListData.isEmpty) {
          isThereIsNoMoreMarathon = true;
        }
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "", name: "Error");
      if (e.response != null) {
        printResponse(e.response!);
      }
    }
  }

  Future<void> getMoreBlogData() async {
    if (isThereIsNoMoreBlog) return;
    try {
      dio.Response response = await dioClient.dio.get(
        "$blogPath?page=${((allInfoController.getBlogList.value?.length ?? 0) / 10).ceil() + 1}",
      );
      if (response.statusCode == 200) {
        List blogList = response.data["data"] ?? [];
        final newBlogs =
            blogList.map((data) => GetBlogModel.fromMap(data)).toList();
        allInfoController.getBlogList.value = [
          ...allInfoController.getBlogList.value ?? [],
          ...newBlogs,
        ];
        if (isThereIsNoMoreBlog == false && blogList.isEmpty) {
          isThereIsNoMoreBlog = true;
        }
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "", name: "Error");
      if (e.response != null) {
        printResponse(e.response!);
      }
    }
  }

  Widget _buildWorkoutPlanShimmer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect({double height = 220, double width = 300}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          const SizedBox(width: 15),
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.6, // 60% for image
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                ),
                const Gap(8),
                Container(
                  height: 8,
                  width: width * 0.8,
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 8),
                ),
                const Gap(4),
                Container(
                  height: 8,
                  width: width * 0.5,
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log(
      allInfoController.allInfo.value.image.toString(),
      name: "allInfoController.allInfo.value.image",
    );
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: RefreshIndicator(
        onRefresh: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NavesPage()),
            (route) {
              return false;
            },
          );
        },
        child: SingleChildScrollView(
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
                              child: Obx(
                                () =>
                                    allInfoController.allInfo.value.image ==
                                            null
                                        ? const Icon(Icons.person, size: 18)
                                        : CachedNetworkImage(
                                          imageUrl:
                                              "$baseAPI/$imagePath/${allInfoController.allInfo.value.imagePath}",
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
                                  allInfoController.allInfo.value.fullName ??
                                      "",
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
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(15.0),
                child: PointsOverviewWidget(),
              ),
              const Gap(20),
              Obx(() {
                final workoutPlans =
                    allInfoController.getWorkoutPlansList.value;
                if (workoutPlans == null) {
                  return _buildWorkoutPlanShimmer();
                }
                if (workoutPlans.isEmpty) {
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
                                UserInfoModel? userInfoModel =
                                    context.read<AuthBloc>().userInfoModel();
                                if (userInfoModel?.isGuest ?? true) {
                                  showSignupPopup(context);
                                  return;
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const CreateWorkoutPlan(),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Create"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => WorkoutPlanOverviewScreen(
                                getWorkoutPlansList:
                                    allInfoController
                                        .getWorkoutPlansList
                                        .value!,
                              ),
                        ),
                      );
                    },
                    child: Padding(
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
                              if (workoutPlans.first.startDate != null &&
                                  workoutPlans.first.endDate != null)
                                Text(
                                  "${getWeekStatus(workoutPlans.first)} Weeks",
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
                                      workoutPlans.first,
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
                  );
                }
              }),
              const Gap(10),
              const Banners(),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Marathon Program",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(
                      () => TextButton(
                        onPressed:
                            allInfoController.marathonList.value?.isEmpty ??
                                    true
                                ? null
                                : () {
                                  widget.pageController.jumpToPage(2);
                                },
                        child: Text(
                          "See All",
                          style: TextStyle(
                            color:
                                allInfoController.marathonList.value?.isEmpty ??
                                        true
                                    ? MyAppColors.mutedGray
                                    : MyAppColors.third,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Obx(() {
                final marathons = allInfoController.marathonList.value;
                if (marathons == null) {
                  return _buildShimmerEffect(height: 220, width: 300);
                }
                return SizedBox(
                  height: marathons.isEmpty ? 120 : 220,
                  child:
                      marathons.isEmpty
                          ? Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: MyAppColors.transparentGray,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.run_circle_outlined,
                                  size: 40,
                                  color: Colors.grey[400],
                                ),
                                const Gap(5),
                                Text(
                                  "Exciting Marathon Events Coming Near You Soon! Stay Tuned.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                          : Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollControllerMarathon,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: marathons.length,
                                  padding: const EdgeInsets.only(right: 15),
                                  itemBuilder: (context, index) {
                                    return getMarathonCard(
                                      width: 300,
                                      height: 220,
                                      context: context,
                                      marathonData: marathons[index],
                                      margin: const EdgeInsets.only(left: 15),
                                    );
                                  },
                                ),
                              ),
                              if (isMarathonLoading)
                                _buildShimmerEffect(height: 220, width: 300),
                            ],
                          ),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Our Blogs & Tips",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(
                      () => TextButton(
                        onPressed:
                            allInfoController.getBlogList.value?.isEmpty ?? true
                                ? null
                                : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const BlogListView(),
                                    ),
                                  );
                                },
                        child: Text(
                          "See All",
                          style: TextStyle(
                            color:
                                allInfoController.getBlogList.value?.isEmpty ??
                                        true
                                    ? MyAppColors.mutedGray
                                    : MyAppColors.third,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 210,
                child: Obx(() {
                  final blogs = allInfoController.getBlogList.value;
                  if (blogs == null) {
                    return _buildShimmerEffect(height: 210, width: 300);
                  }
                  return blogs.isEmpty
                      ? Container(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: MyAppColors.transparentGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.text_snippet_rounded,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                            const Gap(5),
                            Text(
                              "Blogs are Coming Near You Soon! Stay Tuned.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: scrollControllerBlog,
                              itemCount: blogs.length,
                              itemBuilder: (context, index) {
                                return getBlogCard(context, blogs[index]);
                              },
                            ),
                          ),
                          if (isBlogLoading)
                            _buildShimmerEffect(height: 80, width: 160),
                        ],
                      );
                }),
              ),
              const Gap(30),
            ],
          ),
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

bool isSameDate(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

Widget arrowIcon = SvgPicture.string(
  '''<svg width="6" height="12" viewBox="0 0 6 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1 1L5 6L1 11" stroke="#737373" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''',
);
