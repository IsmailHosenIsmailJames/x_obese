import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/screens/blog/blog_details_view.dart';
import 'package:o_xbese/src/theme/colors.dart';

Widget getBlogCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Get.to(() => const BlogDetailsView());
    },
    child: Container(
      width: 165,
      margin: const EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: 160,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: const DecorationImage(
                image: CachedNetworkImageProvider(
                  'https://images.pexels.com/photos/8899546/pexels-photo-8899546.jpeg?auto=compress&cs=tinysrgb&w=600',
                ),

                fit: BoxFit.cover,
              ),
            ),
          ),
          const Gap(8),
          Text(
            '5 min Read',
            style: TextStyle(fontSize: 12, color: MyAppColors.third),
          ),
          const Text('10 Easy Home Workouts', style: TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}
