import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/theme/colors.dart';

import '../details_marathon/marathon_details_view.dart';

Widget getOnsiteMarathon({
  required BuildContext context,
  required EdgeInsetsGeometry margin,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 17, right: 17, top: 20, bottom: 20),
    margin: margin,
    decoration: BoxDecoration(
      image: const DecorationImage(
        image: CachedNetworkImageProvider(
          'https://s3-alpha-sig.figma.com/img/bb6e/32a3/868ec0310f8d575214bf0847062a62aa?Expires=1742169600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=KVWQT57YGpV5uAx9ZFmhrtqM18WLvqUbcBpD5UEZ4l98cpVy9MbDIsScJaI~raP6nVYjkEgAKYjL6AfRhsWDmzYHHmR~XMy3f9qcF5nGDAT0038e-KQJ2VxzYtMHscxWuop2KZhcL5DM8lYB6r2elHO8snsBLQmuUxlYHtl~nhQLj-LR~JGtEpdrzDwg35lye4te6~ra83gbKqFLbI2U8zlTlbYXpLPOnw9yz3PpJ7VyRTlQUGgGFpca3LgIIuOSo8NYqgD5EtIQsWAFTyh8Zg0FJWoPv~tUNIRpe2I~M68fMMJwd4D4PAc6MSOa3A-xjUms~AxzciqtidEji-~igw__',
        ),
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
          'February 10km Challenge Run',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: MyAppColors.primary,
          ),
        ),
        const Gap(5),
        Text(
          'Take on the challenge and achieve greatness, one step at a time',
          style: TextStyle(
            fontSize: 14,
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
              Get.to(() => const MarathonDetailsView(isVirtual: false));
            },
            label: const Text('Physical  Challenge'),
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
