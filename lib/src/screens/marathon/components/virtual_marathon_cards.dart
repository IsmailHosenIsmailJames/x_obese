import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/resources/svg_string.dart';
import 'package:o_xbese/src/screens/marathon/details_marathon/marathon_details_view.dart';
import 'package:o_xbese/src/theme/colors.dart';

Widget getMarathonCard({
  required BuildContext context,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    width: 280,
    margin: margin,

    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      image: DecorationImage(
        image: const CachedNetworkImageProvider(
          'https://static.scientificamerican.com/sciam/cache/file/1DEF27E3-F6FB-4756-9E847D78AEBA16BA_source.jpg?w=900',
        ),
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
          'Every Step Tells a Story',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: MyAppColors.primary,
          ),
        ),
        const Gap(4),
        Text(
          'Run for the journey, celebrate the victory with every step',
          style: TextStyle(fontSize: 14, color: MyAppColors.primary),
        ),
        const Gap(16),
        SizedBox(
          height: 46,
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(iconAlignment: IconAlignment.end),
            onPressed: () {
              Get.to(() => const MarathonDetailsView(isVirtual: true));
            },
            label: const Text(
              'Virtual Challenge',
              style: TextStyle(fontSize: 14),
            ),
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
