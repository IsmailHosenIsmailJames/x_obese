import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:o_xbes/src/theme/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedTab = "login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 240,
            width: 375,
            padding: EdgeInsets.only(
              top: 44,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  MyAppColors.gradiantSignUpStart,
                  MyAppColors.gradiantSignUpEnd,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedTab == "login"
                        ? "HI!\nUnlock Your Fitness\nJourney Toady"
                        : "Welcome !\nJoin the Community\nThat Moves You.",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Gap(10),
                  Text(
                    "Please login to continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(15),
          Container(
            height: 60,
            width: double.infinity,
            margin: EdgeInsets.only(left: 24, right: 24),
            padding: EdgeInsets.only(top: 3, right: 4, bottom: 3, left: 4),
            decoration: BoxDecoration(
              color: MyAppColors.mutedShadowColor,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 53,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: selectedTab == "login"
                            ? Colors.white
                            : Colors.transparent,
                        foregroundColor: selectedTab == "login"
                            ? MyAppColors.primaryColor
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTab = "login";
                        });
                      },
                      child: Text(
                        "Loin",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 53,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: selectedTab == "signup"
                            ? Colors.white
                            : Colors.transparent,
                        foregroundColor: selectedTab == "signup"
                            ? MyAppColors.primaryColor
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTab = "signup";
                        });
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: MyAppColors.primaryColor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: MyAppColors.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: MyAppColors.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                labelText: "Phone Number",
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                hintText: "0181736637",
                hintStyle: TextStyle(
                  color: MyAppColors.grayMutedColor,
                  fontSize: 14,
                ),
                prefixIcon: SizedBox(
                  height: 18,
                  width: 18,
                  child: Center(
                    child: SvgPicture.string(
                        """<svg width="14" height="18" viewBox="0 0 14 18" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="1" y="0.666626" width="11.6667" height="16.6667" rx="3" stroke="#FF655C" stroke-width="1.2" stroke-linejoin="round"/><path d="M6 14.8326H7.66667" stroke="#FF655C" stroke-width="1.2" stroke-linecap="round"/></svg>"""),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  selectedTab == "login" ? "Login" : "Signup",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
