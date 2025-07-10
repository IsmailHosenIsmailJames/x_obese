import "dart:developer";

import "package:cached_network_image/cached_network_image.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

// load more blog data
int nextBlogPageCount = 2;
Future<void> getMoreBlogData() async {
  log("try to get more blogs -> $nextBlogPageCount");
  AllInfoController allInfoController = Get.find();
  DioClient dioClient = DioClient(baseAPI);
  try {
    final response = await dioClient.dio.get(
      "/api/other/v1/blog?page=$nextBlogPageCount&size=10",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      List allBlogs = response.data["data"] ?? [];
      if (allBlogs.isNotEmpty) {
        for (int i = 0; i < allBlogs.length; i++) {
          allInfoController.getBlogList.add(
            GetBlogModel.fromMap(Map<String, dynamic>.from(allBlogs[i])),
          );
        }
        nextBlogPageCount++;
      }
    }
  } on DioException catch (e) {
    if (e.response != null) printResponse(e.response!);
  }
}

class _BlogListViewState extends State<BlogListView> {
  AllInfoController allInfoController = Get.find();
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  @override
  void initState() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        await getMoreBlogData();
        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                getBackButton(context, () {
                  Navigator.pop(context);
                }),
                const Gap(55),
                const Text(
                  "Our Blogs & Tips",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allInfoController.getBlogList.length,
              controller: scrollController,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 154,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image:
                                allInfoController
                                            .getBlogList[index]
                                            .imagePath ==
                                        null
                                    ? null
                                    : DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        allInfoController
                                            .getBlogList[index]
                                            .imagePath!,
                                      ),
                                    ),
                          ),
                        ),
                        const Gap(15),
                        Container(
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: MyAppColors.transparentGray,
                          ),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Center(
                            child: Text(
                              "${allInfoController.getBlogList[index].readTime} min Read",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: MyAppColors.third,
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          allInfoController.getBlogList[index].title ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          allInfoController.getBlogList[index].description ??
                              "",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: MyAppColors.mutedGray,
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
