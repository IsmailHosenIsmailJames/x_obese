import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:x_obese/src/theme/colors.dart";

class Banners extends StatefulWidget {
  const Banners({super.key});

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "https://www.figma.com/file/8frEvJAGHDh0TUQVUTXRF6/image/64d43c488e40faecc1a9270022d1a41a3196b39b",
      "https://www.figma.com/file/8frEvJAGHDh0TUQVUTXRF6/image/c2f11fe8cc3cdede2b7c873468dffd7f7d433600",
      "https://www.figma.com/file/8frEvJAGHDh0TUQVUTXRF6/image/13e1a51d3893a03e861ee79d41b0f78b98505a35",
    ];
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 10, right: 10),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: MyAppColors.third,
              borderRadius: BorderRadius.circular(8),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                height: 120,
                width: 240,
                fit: BoxFit.cover,
                imageUrl: images[index],
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: MyAppColors.primary,
                    ),
                  );
                },

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
          );
        },
      ),
    );
  }
}
