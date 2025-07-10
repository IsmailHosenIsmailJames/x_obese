import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gap/gap.dart";
import "package:x_obese/src/screens/specialists_near_you/models/specialists_near_you_model.dart";
import "package:x_obese/src/theme/colors.dart";

Widget getSpecialistDoctorCard({
  required BuildContext context,
  required SpecialistsNearYouModel data,
  required double width,
  required double height,
  required VoidCallback onTap,
  required nameFontSize,
  required catalogFontSize,
  required distanceFontSize,
  required addressFontSize,
  required iconHeight,
}) {
  return Container(
    height: height,
    width: width,
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: MyAppColors.primary,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: MyAppColors.transparentGray,
          ),
          child:
              data.image == null
                  ? null
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      height: height,
                      width: height,
                      imageUrl: data.image!,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: MyAppColors.mutedGray,
                          ),
                        );
                      },
                      progressIndicatorBuilder: (context, url, progress) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: MyAppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
        ),
        const Gap(10),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.category != null)
              Text(
                data.category!,
                style: TextStyle(
                  color: MyAppColors.third,
                  fontSize: catalogFontSize,
                ),
              ),
            if (data.name != null)
              Text(
                data.name!,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: nameFontSize,
                ),
              ),
            if (data.address != null)
              Text(
                data.address!,
                style: TextStyle(
                  color: MyAppColors.mutedGray,
                  fontSize: addressFontSize,
                ),
              ),
            const Gap(20),
            if (data.distance != null)
              Row(
                children: [
                  SizedBox(
                    height: iconHeight,
                    width: iconHeight,
                    child: SvgPicture.string(
                      """<svg width="14" height="15" viewBox="0 0 14 15" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M13 6.75918C13 10.032 9.25 14.1666 7 14.1666C4.75 14.1666 1 10.032 1 6.75918C1 3.48638 3.68629 0.833252 7 0.833252C10.3137 0.833252 13 3.48638 13 6.75918Z" stroke="#047CEC" stroke-width="1.5"/>
                  <path d="M9 6.83325C9 7.93782 8.10457 8.83325 7 8.83325C5.89543 8.83325 5 7.93782 5 6.83325C5 5.72868 5.89543 4.83325 7 4.83325C8.10457 4.83325 9 5.72868 9 6.83325Z" stroke="#047CEC" stroke-width="1.5"/>
                  </svg>
                  """,
                    ),
                  ),
                  const Gap(5),
                  Text(
                    data.distance!,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: distanceFontSize,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ),
  );
}
