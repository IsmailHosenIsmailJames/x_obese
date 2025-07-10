import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/theme/colors.dart";

import "../details_marathon/marathon_details_view.dart";

Widget getOnsiteMarathon({
  required BuildContext context,
  required MarathonModel marathonData,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    height: 250,
    width: MediaQuery.of(context).size.width,

    margin: margin,
    decoration: BoxDecoration(
      color: MyAppColors.third,
      borderRadius: BorderRadius.circular(4.6),
    ),
    child: Stack(
      children: [
        if (marathonData.imagePath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              height: 250,
              width: MediaQuery.of(context).size.width,
              imageUrl: marathonData.imagePath!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 50,
                    color: MyAppColors.transparentGray.withValues(alpha: 0.5),
                  ),
                );
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(10),
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
                    side: const BorderSide(color: Colors.white, width: 0.5),
                  ),
                  onPressed: () {},
                  child: Text(marathonData.location ?? "Unknown"),
                ),
              ),
              const Gap(10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  marathonData.title ?? "",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: MyAppColors.primary,
                  ),
                ),
              ),
              const Gap(5),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    marathonData.description ?? "",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: MyAppColors.primary,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              const Gap(18),
              SizedBox(
                width: double.infinity,
                height: 46.7,
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
                  label: const Text("Physical  Challenge"),
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
