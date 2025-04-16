import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:x_obese/src/theme/colors.dart';

class IntroPage1 extends StatelessWidget {
  final PageController pageController;
  const IntroPage1({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Image.asset(
            'assets/img/intro/walking.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.string('''
            <svg width="375" height="357" viewBox="0 0 375 357" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M361.95 8.14527C283.05 -17.7147 205.2 24.6453 175.49 43.0253C161.02 51.8053 106.76 82.3653 42.44 66.3453C25.48 62.1253 11.31 55.5253 0 48.8053V53.5453C10.63 60.1653 23.73 66.6353 39.32 71.1553C102.98 89.5953 158.36 61.1153 173.15 52.8853C203.53 35.6353 282.93 -3.73474 360.79 25.0853C365.44 26.8053 370.18 28.8153 374.99 31.1353V13.0753C370.56 11.1853 366.2 9.54527 361.93 8.14527H361.95Z" fill="#FFDA00"/>
            <path d="M198.262 40.5247C256.74 4.09005 340.953 11.4971 375.499 31.0156V356.78H191.007H0.498657V54.538C10.512 60.5437 43.2223 71.8879 59.5774 75.558C89.6175 82.0642 127.168 72.722 142.188 67.0499L165.218 57.5409L175.732 51.5352L198.262 40.5247Z" fill="white" stroke="#FFFFFF"/>
            </svg>
            ''', fit: BoxFit.cover),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <InlineSpan>[
                        const TextSpan(text: 'Your '),
                        TextSpan(
                          text: 'Fitness ',
                          style: TextStyle(color: MyAppColors.third),
                        ),
                        const TextSpan(text: 'Journey Starts Here'),
                      ],
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Set your goals, track your progress, and achieve greatness',
                    style: TextStyle(
                      color: MyAppColors.mutedGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(50),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      },
                      child: const Text(
                        'Get Ready',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
