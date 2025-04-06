import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:o_xbese/src/widgets/back_button.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> {
  AllInfoController allInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                getBackbutton(context, () {
                  Get.back();
                }),
                const Gap(55),
                const Text(
                  'Our Blogs & Tips',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allInfoController.getBlogList.length,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 154,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image:
                                allInfoController
                                            .getBlogList[index]
                                            .imagePath ==
                                        null
                                    ? null
                                    : DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        allInfoController
                                            .getBlogList[index]
                                            .imagePath!,
                                      ),
                                    ),
                          ),
                        ),
                        const Gap(15),
                        Container(
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: MyAppColors.transparentGray,
                          ),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Center(
                            child: Text(
                              '${allInfoController.getBlogList[index].readTime} min Read',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: MyAppColors.third,
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          allInfoController.getBlogList[index].title ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          allInfoController.getBlogList[index].description ??
                              '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: MyAppColors.mutedGray,
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
