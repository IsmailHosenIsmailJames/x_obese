import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:o_xbese/src/widgets/back_button.dart';

class BlogDetailsView extends StatefulWidget {
  const BlogDetailsView({super.key});

  @override
  State<BlogDetailsView> createState() => _BlogDetailsViewState();
}

class _BlogDetailsViewState extends State<BlogDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Container(
                    height: 165,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          '''https://s3-alpha-sig.figma.com/img/5408/3095/0a0d225e09c381cd09235dd9e0618fe7?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=D5oIbSRJEExG8mib5cDBEQbDdVZfxREuyTcA6cCS9hSnQ44QTZA6SGr71vgg4VenkxRxKIQe6d6aUdhXQrcllRx9FMbUmRElJMDGmDjtzygvhq8bZua~cBT3pDYWSH8H4qWWrw0rKUGoq~Pa49yFJmGasytfMUEFWq6a5DbxuLjpwYm9p9y-fiw42rm2bH1vo5QZVGyH9BjN73YRD7Eo3vrgbW2KDAUVhclZoBAqYZOGbTlJOeRFBo3R9zUbPQu54ru0ktJD7wQJjPulHRcKPaMYgDGOFtXeGRZVam7sJrvdd0srqzz03heJSZ91awgmEg7OKoWcebnf1q2JrKIqpw__''',
                        ),

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Gap(15),
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
                            '5 min Read',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: MyAppColors.third,
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      const Text(
                        '10 Easy Home Workouts ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(color: Colors.transparent),
                      const Text(
                        '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's  When an unknown printer took a galley of type and scrambled it to make a type specimen book.
                         \nIt has survived not only five centuries, but also the leap into electronic typesetting, Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.
                         \nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.''',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
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
              padding: const EdgeInsets.all(15.0),
              child: getBackbutton(context, () {
                Get.back();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
