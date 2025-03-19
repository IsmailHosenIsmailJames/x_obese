import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:o_xbese/src/screens/auth/controller/auth_controller.dart';
import 'package:o_xbese/src/screens/auth/login/otp_page.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:o_xbese/src/widgets/loading_popup.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  String pageName = 'login';
  final AuthController authController = Get.put(AuthController());
  TextEditingController phoneController = TextEditingController();
  // from key
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: Stack(
        children: [
          SvgPicture.string('''
<svg width="375" height="247" viewBox="0 0 375 247" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M361.95 176.04C283.05 150.18 205.2 192.54 175.49 210.92C161.02 219.7 106.76 250.26 42.44 234.24C25.48 230.02 11.31 223.42 0 216.7V221.44C10.63 228.06 21.91 235.98 37.5 240.5C101.16 258.94 164.21 230.23 179 222C209.38 204.75 282.93 164.16 360.79 192.98C365.44 194.7 370.18 196.71 374.99 199.03V180.97C370.56 179.08 366.2 177.44 361.93 176.04H361.95Z" fill="#FFDE1A"/>
<path d="M175.49 210.93C205.2 192.54 283.05 150.19 361.95 176.05C366.22 177.45 370.58 179.09 375.01 180.98V0H0.0100098V216.71C11.31 223.43 25.48 230.03 42.45 234.25C106.77 250.27 161.03 219.71 175.5 210.93H175.49Z" fill="#047CEC"/>
</svg>

''', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.only(left: 23, bottom: 23, right: 23),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pageName == 'login' ? 'Hi!' : 'Welcome  !',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: MyAppColors.primary,
                          ),
                        ),
                        const Gap(7),
                        Text(
                          pageName == 'login'
                              ? 'Unlock Your Fitness Journey Today'
                              : 'Join the Community That Moves You.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: MyAppColors.primary,
                          ),
                        ),
                        Text(
                          pageName == 'login'
                              ? 'Please login to continue'
                              : 'Please enter your information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: MyAppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(120),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: MyAppColors.transparentGray,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 53,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  pageName == 'login'
                                      ? MyAppColors.primary
                                      : MyAppColors.transparentGray,
                              foregroundColor:
                                  pageName == 'login'
                                      ? MyAppColors.third
                                      : Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                pageName = 'login';
                              });
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 53,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor:
                                  pageName == 'signup'
                                      ? MyAppColors.primary
                                      : MyAppColors.transparentGray,
                              foregroundColor:
                                  pageName == 'signup'
                                      ? MyAppColors.third
                                      : Colors.black,
                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                pageName = 'signup';
                              });
                            },
                            child: const Text(
                              'Signup',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(50),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: phoneController,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length != 11 || int.tryParse(value) == null) {
                          return 'Please enter a valid phone number';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: MyAppColors.transparentGray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: MyAppColors.transparentGray,
                          ),
                        ),

                        label: const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        hintText: '0181736637',
                        hintStyle: TextStyle(color: MyAppColors.mutedGray),
                        prefixIcon: SizedBox(
                          width: 11.667,
                          height: 16.667,
                          child: SvgPicture.string(
                            '''<svg width="14" height="18" viewBox="0 0 14 18" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="1" y="0.666504" width="11.6667" height="16.6667" rx="3" stroke="#047CEC" stroke-width="1.2" stroke-linejoin="round"/>
                        <path d="M6 14.8325H7.66667" stroke="#047CEC" stroke-width="1.2" stroke-linecap="round"/>
                        </svg>
                        ''',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(50),
                  SafeArea(
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() == true) {
                            if (!(await InternetConnection()
                                .hasInternetAccess)) {
                              Fluttertoast.showToast(
                                msg: 'Check Internet Connection!',
                              );
                              return;
                            }
                            showLoadingPopUp(context);
                            try {
                              dio.Response? response =
                                  pageName == 'login'
                                      ? await authController.login(
                                        phoneController.text,
                                      )
                                      : await authController.signup(
                                        phoneController.text,
                                      );
                              if (response != null) {
                                Get.to(
                                  () => OtpPage(
                                    isSignup:
                                        pageName == 'login' ? false : true,
                                    phone: phoneController.text,
                                    response: response,
                                  ),
                                );
                              }
                            } catch (e) {
                              log(e.toString());
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          pageName == 'login' ? 'Log In' : 'Sign Up',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
