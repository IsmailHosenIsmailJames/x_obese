import 'package:flutter/material.dart';
import 'package:o_xbese/src/screens/intro/pages/intro_page_1.dart';
import 'package:o_xbese/src/screens/intro/pages/intro_page_2.dart';
import 'package:o_xbese/src/screens/intro/pages/intro_page_3.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          children: [
            IntroPage1(pageController: pageController),
            IntroPage2(pageController: pageController),
            IntroPage3(pageController: pageController),
          ],
        ),
        Align(
          alignment: const Alignment(0.9, 0.2),
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3,

            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
              activeDotColor: MyAppColors.third,
              dotHeight: 10,
              dotWidth: 10,
              dotColor: MyAppColors.mutedGray,
            ),
            onDotClicked: (index) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            },
          ),
        ),
      ],
    );
  }
}
