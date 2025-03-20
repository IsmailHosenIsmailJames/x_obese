import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/resources/svg_string.dart';
import 'package:o_xbese/src/screens/controller/info_collector/controller/controller.dart';
import 'package:o_xbese/src/screens/blog/blog_list_view.dart';
import 'package:o_xbese/src/screens/create_workout_plan/create_workout_plan.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:o_xbese/src/widgets/get_blog_card.dart';
import 'package:o_xbese/src/screens/marathon/components/virtual_marathon_cards.dart';
import 'package:o_xbese/src/widgets/points_overview_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userBox = Hive.box('user');
  AllInfoController allInfoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: MyAppColors.transparentGray,
                      child: CachedNetworkImage(
                        imageUrl:
                            '$baseAPI/uploads/photos/${allInfoController.allInfo.value.image}',
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello 👋',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Obx(
                        () => Text(
                          allInfoController.allInfo.value.fullName,
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
                  IconButton(
                    onPressed: () {},
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
            Padding(
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
                          'Workout Plan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(4),
                        SizedBox(
                          width: 180,
                          child: Text(
                            'Create Your Workout plan',
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
                        child: const Text('Create'),
                      ),
                    ),
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
                    'Marathon Program',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(color: MyAppColors.third),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 220,
              child: Obx(
                () => ListView.builder(
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
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Our Blogs & Tips',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const BlogListView());
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(color: MyAppColors.third),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 210,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  getBlogCard(context),
                  getBlogCard(context),
                  getBlogCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
