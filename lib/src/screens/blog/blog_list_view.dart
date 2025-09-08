import "dart:developer";

import "package:cached_network_image/cached_network_image.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:shimmer/shimmer.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/blog/blog_details_view.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:x_obese/src/widgets/banners/banners.dart";

mixin PaginationController<T extends StatefulWidget> on State<T> {
  void addPaginationListener({
    required ScrollController controller,
    required Future<void> Function() onFetch,
    required ValueGetter<bool> isLoading,
    required ValueSetter<bool> setLoading,
    double threshold = 0.9,
  }) {
    controller.addListener(() async {
      if (controller.position.hasContentDimensions &&
          !isLoading() &&
          controller.position.pixels >=
              controller.position.maxScrollExtent * threshold) {
        if (!mounted) return;
        setLoading(true);
        try {
          await onFetch();
        } finally {
          if (mounted) {
            setLoading(false);
          }
        }
      }
    });
  }
}

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> with PaginationController<BlogListView> {
  AllInfoController allInfoController = Get.find();
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    addPaginationListener(
      controller: scrollController,
      onFetch: _getMoreBlogData,
      isLoading: () => isLoading,
      setLoading: (loading) => setState(() => isLoading = loading),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _getMoreBlogData() async {
    final page = ((allInfoController.getBlogList.value?.length ?? 0) / 10).ceil() + 1;
    log("try to get more blogs -> page $page");
    DioClient dioClient = DioClient(baseAPI);
    try {
      final response = await dioClient.dio.get(
        "/api/other/v1/blog?page=$page&size=10",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List allBlogs = response.data["data"] ?? [];
        if (allBlogs.isNotEmpty) {
          final newBlogs = allBlogs
              .map((data) => GetBlogModel.fromMap(Map<String, dynamic>.from(data)))
              .toList();
          allInfoController.getBlogList.value = [
            ...allInfoController.getBlogList.value ?? [],
            ...newBlogs,
          ];
        }
      }
    } on DioException catch (e) {
      if (e.response != null) printResponse(e.response!);
    }
  }

  Widget _buildBlogItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 154,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Gap(15),
            Container(
              height: 20,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const Gap(8),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.white,
            ),
            const Gap(8),
            Container(
              height: 15,
              width: double.infinity,
              color: Colors.white,
            ),
            const Gap(4),
            Container(
              height: 15,
              width: double.infinity,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            left: false,
            right: false,
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
            child: Obx(() {
              final blogs = allInfoController.getBlogList.value;
              if (blogs == null) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => _buildBlogItemShimmer(),
                );
              }
              return ListView.builder(
                itemCount: blogs.length + (isLoading ? 1 : 0),
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (index >= blogs.length) {
                    return _buildBlogItemShimmer();
                  }
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogDetailsView(
                                blogData: blogs[index],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            bottom: 10,
                            top: index == 0 ? 0 : 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (blogs[index].imagePath != null)
                                Container(
                                  height: 154,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: MyAppColors.third,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      height: 154,
                                      width: MediaQuery.of(context).size.width,
                                      imageUrl: blogs[index].imagePath!,
                                      errorWidget: (context, url, error) {
                                        return Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: MyAppColors.transparentGray
                                                .withValues(alpha: 0.5),
                                          ),
                                        );
                                      },
                                      progressIndicatorBuilder: (
                                        context,
                                        url,
                                        progress,
                                      ) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: MyAppColors.primary,
                                          ),
                                        );
                                      },
                                      fit: BoxFit.cover,
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
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    "${blogs[index].readTime} min Read",
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
                                blogs[index].title ?? "",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                blogs[index].description ?? "",
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
                      Divider(color: MyAppColors.transparentGray),
                      if (index % 2 == 0) const Gap(10),
                      if (index % 2 == 0) const Banners(),
                      if (index % 2 == 0) const Gap(10),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}