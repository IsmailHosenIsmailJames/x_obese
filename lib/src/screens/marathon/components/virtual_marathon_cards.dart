import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:gap/gap.dart";
import "package:x_obese/src/resources/svg_string.dart";
import "package:x_obese/src/screens/marathon/details_marathon/marathon_details_view.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/theme/colors.dart";

Widget getMarathonCard({
  required BuildContext context,
  required MarathonModel marathonData,
  required double width,
  required double height,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    width: width,
    margin: margin,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: MyAppColors.third,
    ),
    child: Stack(
      children: [
        if (marathonData.imagePath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                CachedNetworkImage(
                  width: width,
                  height: height,
                  imageUrl: marathonData.imagePath.toString(),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: MyAppColors.transparentGray.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: width,
                  height: height,
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(10),
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
              SizedBox(
                width: 300,
                child: Text(
                  marathonData.title ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyAppColors.primary,
                  ),
                ),
              ),
              const Gap(4),
              Expanded(
                child: SizedBox(
                  child: Text(
                    marathonData.description ?? "",
                    // safeSubString(marathonData.description ?? "", 100),
                    style: TextStyle(fontSize: 12, color: MyAppColors.primary),
                    overflow: TextOverflow.fade,
                    maxLines: 4,
                  ),
                ),
              ),
              const Gap(16),
              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    iconAlignment: IconAlignment.end,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MarathonDetailsView(
                              isVirtual: marathonData.type == "virtual",
                              marathonData: marathonData,
                            ),
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
        ),
      ],
    ),
  );
}
