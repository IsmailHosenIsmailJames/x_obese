import "package:flutter/material.dart";
import "package:x_obese/src/screens/intro/pages/intro_page_1.dart";
import "package:x_obese/src/screens/intro/pages/intro_page_2.dart";
import "package:x_obese/src/screens/intro/pages/intro_page_3.dart";
import "package:x_obese/src/screens/intro/pages/intro_page_4.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              IntroPage1(pageController: pageController),
              IntroPage2(pageController: pageController),
              IntroPage3(pageController: pageController),
              IntroPage4(pageController: pageController),
            ],
          ),
          Align(
            alignment: const Alignment(0.9, 0.25),
            child: SmoothPageIndicator(
              controller: pageController,
              count: 4,

              axisDirection: Axis.horizontal,
              effect: ExpandingDotsEffect(
                activeDotColor: MyAppColors.third,
                dotHeight: 10,
                dotWidth: 10,
                dotColor: MyAppColors.transparentGray,
              ),
              onDotClicked: (index) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
