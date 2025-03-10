import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:o_xbese/src/theme/colors.dart';

class MarathonDetailsView extends StatefulWidget {
  final bool isVirtual;
  const MarathonDetailsView({super.key, required this.isVirtual});

  @override
  State<MarathonDetailsView> createState() => _MarathonDetailsViewState();
}

class _MarathonDetailsViewState extends State<MarathonDetailsView> {
  bool isJoined = false;
  @override
  Widget build(BuildContext context) {
    final padding = const EdgeInsets.only(left: 15, right: 15, bottom: 15);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 194,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl:
                    'https://s3-alpha-sig.figma.com/img/2994/ba6b/3b010d2ea55fb31ad7d5c5228e7d651b?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=m1LpTv2G0rJgDKyOctBmjmETVRAulB3K1Fu6H~uuFadf-oi1dg4lpqT-h5VIoKP7lJOMABosM5PQ2VGEQyuQyl0pojyD3PyVk1uIlWsZ2fgSJnXjNV5CX6v8Qc~lN5glboVIH2zx2NO1isdvcV8jPcW-i3DxK5ap0nktBzEqBECcO4dqoKhbmE0wpf-30SyvfZSHmtap6bfgKH2zTbwE9JrpnKLbCyf-ikLv-cwsJZVJFFTAgkwqCFT69PclxYFMfMgz0o4jxot9RGgtBI7Wy7YrynoS83FuWyPLAPk8Xh7VX79eG~E1xcfXvOp58mrCP4Lk69QpbCiqGv308O01Jg__',
                fit: BoxFit.cover,
              ),
            ),
            const Divider(color: Colors.transparent),
            Padding(
              padding: padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'February 5k Challenge Run',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const Gap(8),
                  Text(
                    'A program designed to push your limits, build endurance, and celebrate your strength!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: MyAppColors.mutedGray,
                    ),
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 70,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 30,
                                width: 30,

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: MyAppColors.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      'https://s3-alpha-sig.figma.com/img/10e7/e10b/7e6b601608cd9ac2ecb115d218c668e8?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ZQwi96eUkaU3YatmgfS~2xVH9txm9wBTdjd6NWwW2bLCWz2Vgi9UeixhWQNXKR~441aeC9UhYqcifNl3in3THIsch1DtXfnBK2f9~5v~tn522n1mcF6DZ0NtP7oMWHmlQpadhJJdRpW5y8V8m-KLT~RSwrwlqo3orcN-GDi08CxKNROB3B6PNDAtYapxIKIp6XW6DBA5ECF10pMerCzfVIbGBCjrnOzJFp9ZYajSoZWerLWjXwvjZErDNSmIBX2g-efmKYU0wqfrLxn2Vnn~ls3wINZK61j20I1~s8QwhW3z0itHthj8h3upSiajDajNJ~1Qo3ucwdMm8Me91V2D7w__',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 30,
                                width: 30,

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: MyAppColors.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      'https://s3-alpha-sig.figma.com/img/d88f/c3c2/f75cae66092d790a30fb8a602a9f19c3?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=XF0vYbiJiHFBwhzaUQeeXoT7tMDtr69sBULROrUYp-kIU-Ij6XxZ~~QR2CB5qDzvKWQiPmBlg-UAneGG1M5uYnapLQGgZWgo3seZHWJsc5~1LUgG-tSegY3SXnl55dmM-g0ub4ovvMzfUAlVT0cQFrCipFhiNlyBt-sllOJ7y45BfWahrajs7ub4hDJVNUioYMOdjdf3klsYhjvyhwyi2BAmti3Z4ZTKx5ehMzPv4bvlGlTmU-1Sfw6okCtacj3avuyRFpoIrUj0-KqHobbbrRXpBE4YyiLycUYXWuaFdjnl5M1xc1r3nHZkbc1KU1-BfZY19q~Y8yVxOywyVtMjPQ__',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 30,
                                width: 30,

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: MyAppColors.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      'https://s3-alpha-sig.figma.com/img/bfa5/0409/11a8acfff43407745e1d6b67f9b75523?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=YE4QJ1kXIUBFaDn43xajUDW99cs6i37zcqn~Cfks3xfVJHt9lXFknjlFaPfFeHQjSm0tsydQB1SJ6KDBcQvzLkgcyCv7nueF8r-K-KGkJcXnZ0xe349fXO4nVNOtwbq5QGkP7DEd0kuQ1-WJGWdU5rx3925Don-cTFvy3DN5WuTjIrEU5iU~WbG5mjD1tg0GT3S7oAnX4StpXIhZyI9h1TLyBnXTdrW8wko6cTo-QGBdIuVLIqcZwbm7SeEH0D8Rl2kJhJ80PQR4POERGkeGp6E3tkBZdeul-96yqhI-abSo~LrZuEzOyNoN6f7qKZJ4sNWdEPMvladsH65VzG1XlQ__',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Text(
                        '200+ Participants',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  const Text(
                    'About Challenge :',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Gap(12),
                  Text(
                    'A program designed to push your limits, build endurance, and celebrate your strength! Whether this program offers personalized training plans, progress tracking, and a vibrant community to keep you motivated every step of the way.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: MyAppColors.mutedGray,
                    ),
                  ),
                  const Gap(24),
                  const Text(
                    'When :',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Gap(13),
                  Row(
                    children: [
                      SvgPicture.string(
                        '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M3 9V18C3 20.2091 4.79086 22 7 22H17C19.2091 22 21 20.2091 21 18V9M3 9V7.5C3 5.29086 4.79086 3.5 7 3.5H17C19.2091 3.5 21 5.29086 21 7.5V9M3 9H21M16 2V5M8 2V5" stroke="#AEA8A8" stroke-width="1.5" stroke-linecap="round"/>
        </svg>''',
                      ),
                      const Gap(10),
                      Text(
                        'February 21,2025  TO  March 15,2025',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  const Text(
                    'What you’ll get :',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Gap(13),
                  Row(
                    children: [
                      SvgPicture.string(
                        '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M9 20V10C9 8.89543 9.89543 8 11 8H13C14.1046 8 15 8.89543 15 10V20M9 20C9 21.1046 9.89543 22 11 22H13C14.1046 22 15 21.1046 15 20M9 20V14C9 12.8954 8.10457 12 7 12H5C3.89543 12 3 12.8954 3 14V20C3 21.1046 3.89543 22 5 22H7C8.10457 22 9 21.1046 9 20ZM15 20V16C15 14.8954 15.8954 14 17 14H19C20.1046 14 21 14.8954 21 16V20C21 21.1046 20.1046 22 19 22H17C15.8954 22 15 21.1046 15 20Z" stroke="#AEA8A8" stroke-width="1.5"/>
          <path d="M11.5245 1.96353C11.6741 1.50287 12.3259 1.50287 12.4755 1.96353L12.6324 2.4463C12.6993 2.65232 12.8913 2.7918 13.1079 2.7918H13.6155C14.0999 2.7918 14.3013 3.4116 13.9094 3.6963L13.4988 3.99468C13.3235 4.122 13.2502 4.34768 13.3171 4.5537L13.474 5.03647C13.6237 5.49713 13.0964 5.88019 12.7046 5.59549L12.2939 5.29712C12.1186 5.1698 11.8814 5.1698 11.7061 5.29712L11.2954 5.59549C10.9036 5.88019 10.3763 5.49713 10.526 5.03647L10.6829 4.5537C10.7498 4.34768 10.6765 4.122 10.5012 3.99468L10.0906 3.6963C9.69871 3.4116 9.90009 2.7918 10.3845 2.7918H10.8921C11.1087 2.7918 11.3007 2.65232 11.3676 2.4463L11.5245 1.96353Z" fill="#AEA8A8"/>
        </svg>''',
                      ),
                      const Gap(10),
                      Text(
                        'Medal & Finisher Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  if (!isJoined)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        onPressed: () {
                          setState(() {
                            isJoined = true;
                          });
                        },
                        label: Text(
                          widget.isVirtual ? 'Join Challenge' : 'Register Now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),

                  if (isJoined)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Activity Now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  if (isJoined) Gap(24),
                  if (isJoined)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyAppColors.third,
                          foregroundColor: MyAppColors.primary,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'View Leaderboard',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
