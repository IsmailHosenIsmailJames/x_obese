import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:x_obese/src/screens/blog/blog_details_view.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/theme/colors.dart";

Widget getBlogCard(BuildContext context, GetBlogModel blogData) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlogDetailsView(blogData: blogData),
        ),
      );
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
              color: MyAppColors.third,
            ),
            child:
                blogData.imagePath == null
                    ? null
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        height: 80,
                        width: 160,
                        imageUrl: blogData.imagePath!,
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
                    ),
          ),
          const Gap(8),
          Text(
            "${blogData.readTime} min Read",
            style: TextStyle(fontSize: 12, color: MyAppColors.third),
          ),
          Text(blogData.title ?? "", style: const TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}
