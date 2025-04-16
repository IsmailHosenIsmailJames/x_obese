import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/core/common/functions/safe_sub_string.dart';
import 'package:x_obese/src/resources/svg_string.dart';
import 'package:x_obese/src/screens/marathon/details_marathon/marathon_details_view.dart';
import 'package:x_obese/src/screens/marathon/models/marathon_model.dart';
import 'package:x_obese/src/theme/colors.dart';

Widget getMarathonCard({
  required BuildContext context,
  required MarathonModel marathonData,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    width: 300,
    margin: margin,

    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      image:
          marathonData.imagePath == null
              ? null
              : DecorationImage(
                image: CachedNetworkImageProvider(marathonData.imagePath ?? ''),
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
                fit: BoxFit.cover,
              ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 33,
          width: 33,
          child: SvgPicture.string(runningMarathonProgramSVGIcon),
        ),
        const Gap(14),
        Text(
          marathonData.title ?? '',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MyAppColors.primary,
          ),
        ),
        const Gap(4),
        Text(
          safeSubString(marathonData.description ?? '', 100),
          style: TextStyle(fontSize: 12, color: MyAppColors.primary),
        ),
        const Gap(16),
        SizedBox(
          height: 46,
          width: double.infinity,
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
            label: Text(
              '${marathonData.type == 'virtual' ? 'Virtual' : 'Onsite'}, Challenge',
              style: const TextStyle(fontSize: 14),
            ),
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
