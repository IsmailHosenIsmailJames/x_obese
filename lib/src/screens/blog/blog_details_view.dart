import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:url_launcher/url_launcher.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";

class BlogDetailsView extends StatefulWidget {
  final GetBlogModel blogData;
  const BlogDetailsView({super.key, required this.blogData});

  @override
  State<BlogDetailsView> createState() => _BlogDetailsViewState();
}

class _BlogDetailsViewState extends State<BlogDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.blogData.imagePath ?? "",
                  fit: BoxFit.fitWidth,
                  errorWidget:
                      (context, url, error) => SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                  alignment: Alignment.center,
                  progressIndicatorBuilder:
                      (context, url, progress) => SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                progress.totalSize == null
                                    ? null
                                    : (progress.downloaded /
                                        progress.totalSize!),
                          ),
                        ),
                      ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Container(
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: MyAppColors.transparentGray,
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child: Text(
                            "${widget.blogData.readTime} min Read",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyAppColors.third,
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      Text(
                        widget.blogData.title ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(color: Colors.transparent),

                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 12,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                      GptMarkdown(widget.blogData.description ?? ""),

                      const Divider(color: Colors.transparent),
                      Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 12,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                      SafeArea(
                        bottom: true,
                        right: false,
                        left: false,
                        top: false,
                        child: GptMarkdown(
                          widget.blogData.details ?? "",
                          onLinkTap: (url, title) {
                            launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          linkBuilder: (context, text, url, style) {
                            return Text.rich(
                              text,
                              style: style.copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: getBackButton(context, () {
                Navigator.pop(context);
              }, size: const Size(40, 40)),
            ),
          ),
        ],
      ),
    );
  }
}
