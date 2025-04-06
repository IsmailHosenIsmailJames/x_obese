import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/core/common/functions/safe_sub_string.dart';
import 'package:x_obese/src/screens/marathon/models/model.dart';
import 'package:x_obese/src/theme/colors.dart';

import '../details_marathon/marathon_details_view.dart';

Widget getOnsiteMarathon({
  required BuildContext context,
  required MarathonModel marathonData,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: margin,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: CachedNetworkImageProvider(marathonData.imagePath ?? ''),
        fit: BoxFit.cover,
        opacity: 0.5,
      ),
      color: Colors.black,
      borderRadius: BorderRadius.circular(4.6),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyAppColors.third,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text('Uttara'),
          ),
        ),
        const Gap(16),
        Text(
          marathonData.title ?? '',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: MyAppColors.primary,
          ),
        ),
        const Gap(5),
        Text(
          safeSubString(marathonData.description ?? '', 100),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: MyAppColors.primary,
          ),
        ),
        const Gap(18),
        SizedBox(
          width: double.infinity,
          height: 46.7,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(iconAlignment: IconAlignment.end),
            onPressed: () {
              Get.to(
                () => MarathonDetailsView(
                  isVirtual: marathonData.type == 'virtual',
                  marathonData: marathonData,
                ),
              );
            },
            label: const Text('Physical  Challenge'),
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
