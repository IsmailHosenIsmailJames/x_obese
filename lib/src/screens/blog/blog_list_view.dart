import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:o_xbese/src/widgets/back_button.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                getBackbutton(context, () {
                  Get.back();
                }),
                const Gap(55),
                const Text(
                  'Our Blogs & Tips',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 154,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              'https://s3-alpha-sig.figma.com/img/5408/3095/0a0d225e09c381cd09235dd9e0618fe7?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=D5oIbSRJEExG8mib5cDBEQbDdVZfxREuyTcA6cCS9hSnQ44QTZA6SGr71vgg4VenkxRxKIQe6d6aUdhXQrcllRx9FMbUmRElJMDGmDjtzygvhq8bZua~cBT3pDYWSH8H4qWWrw0rKUGoq~Pa49yFJmGasytfMUEFWq6a5DbxuLjpwYm9p9y-fiw42rm2bH1vo5QZVGyH9BjN73YRD7Eo3vrgbW2KDAUVhclZoBAqYZOGbTlJOeRFBo3R9zUbPQu54ru0ktJD7wQJjPulHRcKPaMYgDGOFtXeGRZVam7sJrvdd0srqzz03heJSZ91awgmEg7OKoWcebnf1q2JrKIqpw__',
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
                            '5 min Read',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyAppColors.third,
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      const Text(
                        '10 Easy Home Workouts ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        'Stay fit with simple exercises like push-ups, planks, lunges, and jumping jacks, requiring no equipment ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 154,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              'https://s3-alpha-sig.figma.com/img/9bee/b62a/1d2899d70ae6158ba04137f008db7d4e?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=hBflyMMd5353dWDjkEndeGYG5ilO7kNHmmuFXE0YeKPYpD6nV-1zNRFqzgOnAAt54oJ0rfvUYIDjCC~jAdt3jWWUQ-w0S0Z-t7Nu26H2usjnDOpYmdzyfxXT9BBFdxQ66g7hgjbcJJWJNZAdyt7YCYVOekl5gFqlC8BrYj9N6~cgFgxb~-ZbjGqWJEdpO42ZBgkDx6l7M6KuB8E31GCBmIUk~8AddXESWfUSw8fY9S3Ck-tHSKi6v~OqD0NpLd9fUZdYCbCH9xlCdlgHbC0lNZYiyhvkhhxeHEl5Nn5xX9SiiNJJlbAPMXPW8TAkh-UqMiiav2mC0ham2HLUC5Hp3Q__',
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
                            '2 min Read',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyAppColors.third,
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      const Text(
                        'The Role of Diet & Exercise',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        'Stay fit with simple exercises like push-ups, planks, lunges, and jumping jacks, requiring no equipment ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
