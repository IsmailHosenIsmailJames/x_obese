import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/screens/create_workout_plan/controller/create_workout_plan_controller.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';
import 'package:x_obese/src/widgets/text_input_decoration.dart';
import 'package:toastification/toastification.dart';

class CreateWorkoutPlanPage1 extends StatefulWidget {
  final PageController pageController;
  const CreateWorkoutPlanPage1({super.key, required this.pageController});

  @override
  State<CreateWorkoutPlanPage1> createState() => _CreateWorkoutPlanPage1State();
}

double getUserBMI(double weight, double heightFeet, double heightInch) {
  // convert  feet inch to meter
  double height = (heightFeet * 12 + heightInch) * 0.0254;
  // calculate BMI
  double bmi = weight / (height * height);
  return bmi;
}

class _CreateWorkoutPlanPage1State extends State<CreateWorkoutPlanPage1> {
  final CreateWorkoutPlanController createWorkoutPlanController = Get.find();
  AllInfoController allInfoController = Get.find();

  // calculate BMI

  late double userBMI = getUserBMI(
    (allInfoController.allInfo.value.weight ?? 0).toDouble(),
    (allInfoController.allInfo.value.heightFt ?? 0).toDouble(),
    (allInfoController.allInfo.value.heightIn ?? 0).toDouble(),
  ).toPrecision(2);
  @override
  void initState() {
    createWorkoutPlanController.userBMI.value = userBMI;
    super.initState();
  }

  late TextEditingController textEditingController = TextEditingController(
    text:
        createWorkoutPlanController.createWorkoutPlanModel.value.weightGoal ??
        '6',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getBackButton(context, () {
                    Get.back();
                  }),
                  const Gap(55),
                  const Text(
                    'Workout Goal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Gap(22),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your BMI : $userBMI',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                getBMICategory(userBMI).name.capitalizeFirst,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff098202),
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),
                          SizedBox(
                            height: 40,
                            child: Stack(
                              children: [
                                Container(
                                  height: 28,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffFD1D04),
                                        Color(0xffFFAF20),
                                        Color(0xffDFA91C),
                                        Color(0xff008000),
                                        Color(0xffDFA91C),
                                        Color(0xffFFAF20),
                                        Color(0xffFD1D04),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SvgPicture.string(
                                    '''<svg xmlns="http://www.w3.org/2000/svg" width="14" height="17" viewBox="0 0 14 17" fill="none">
                    <path d="M8.07342 14.7584C7.59014 16.0642 5.7432 16.0642 5.25992 14.7584L0.91581 3.02064C0.553252 2.04101 1.27799 1 2.32256 1H11.0108C12.0553 1 12.7801 2.041 12.4175 3.02063L8.07342 14.7584Z" fill="white" stroke="#9ADF8F"/>
                  </svg>''',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('18.4'),
                              Text('24.9'),
                              Text('29.9'),
                            ],
                          ),
                        ],
                      ),
                      const Gap(32),
                      const Text(
                        'Workout Goal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getWorkoutGoalCard(
                            context: context,
                            title: 'Gain Muscle',
                            svg:
                                '''<svg xmlns="http://www.w3.org/2000/svg" width="61" height="62" viewBox="0 0 61 62" fill="none">
                    <path d="M26.4332 61.1769C15.0108 61.1769 9.19941 56.945 8.11493 56.061C4.24853 56.0492 0.818271 52.6543 0.676817 52.5128C0.570727 52.4067 0.5 52.2535 0.5 52.1003C0.5 42.9883 2.96365 32.2024 7.43124 21.7348C11.1916 12.9293 16.1542 4.97255 20.3625 0.988272C20.4686 0.882181 20.6218 0.823242 20.7633 0.823242H35.3919C35.5334 0.823242 35.6749 0.870393 35.7809 0.976484L40.1896 4.86646C40.3782 5.03149 40.4371 5.3144 40.3428 5.55016L37.891 11.1022C37.8084 11.279 37.6434 11.4087 37.443 11.4441L28.4725 12.9175C28.2367 12.9529 28.001 12.8468 27.8831 12.6464L26.3978 10.2653L23.4391 9.78198C21.1876 13.7898 21.3055 18.8586 21.4234 24.2221C21.5295 29.0786 21.6473 34.4775 20.0088 39.8173C20.7986 39.0511 21.8006 38.2024 22.9558 37.4244C26.999 34.7132 30.9951 34.3714 34.4961 36.446C36.5 37.6366 37.9499 38.9922 38.7043 39.7938C42.0639 33.2397 47.6749 31.8252 51.8595 31.8252C56.5157 31.8252 60.335 33.4991 60.5 33.5698L60.0285 34.6425C59.9931 34.6307 56.2564 33.004 51.8595 33.004H51.8242C46.0128 33.004 41.8163 35.7388 39.3762 41.0786C39.2937 41.2673 39.1169 41.3969 38.9047 41.4205C38.7043 41.4441 38.5039 41.3616 38.3743 41.2083C38.3625 41.1847 36.6886 39.0983 33.8831 37.4362C30.7593 35.5855 27.3173 35.9038 23.6277 38.3557C20.7986 40.2417 18.889 42.7407 18.8772 42.7761C18.7004 43.0118 18.3703 43.0826 18.111 42.9293C17.8517 42.7761 17.7456 42.4578 17.8635 42.1867C20.5039 36.1749 20.3743 30.1042 20.2446 24.2221C20.1267 18.5285 20.0088 13.1533 22.6375 8.8036C22.7672 8.6032 23.0029 8.48532 23.2387 8.53248L26.8576 9.12187C27.0226 9.14544 27.1758 9.25153 27.2583 9.39299L28.6847 11.668L36.9597 10.3124L39.1051 5.45585L35.1916 2.00202H21.0108C16.944 5.93916 12.1699 13.6484 8.51572 22.1946C4.15422 32.4146 1.72593 42.9293 1.67878 51.8409C2.38605 52.4893 5.20334 54.8822 8.13851 54.8822H8.30354C8.45678 54.8822 8.59823 54.9293 8.71611 55.0354C8.77505 55.0826 14.445 59.9981 26.4332 59.9981C38.4332 59.9981 43.1365 56.6621 43.1837 56.6268C43.3841 56.4853 43.6552 56.4735 43.8556 56.6032L49.1601 60.0806L48.5118 61.0708L43.5255 57.8056C42.2171 58.6071 37.1719 61.1769 26.4332 61.1769Z" fill="#8AC6FF"/>
                    <path d="M25.2058 5.95969L27.272 9.40857L26.2606 10.0145L24.1944 6.56558L25.2058 5.95969ZM29.0102 4.44177L31.2399 11.7744L30.1118 12.1174L27.8821 4.7848L29.0102 4.44177ZM32.6032 3.90637L34.5314 11.2472L33.3915 11.5466L31.4633 4.20578L32.6032 3.90637ZM35.5985 3.43604L37.9326 10.6742L36.8104 11.0361L34.4763 3.79792L35.5985 3.43604ZM56.3028 60.8114C52.2478 51.0157 43.3362 45.9469 43.2419 45.8998L43.8195 44.8742C43.9138 44.9332 46.1889 46.218 49.0179 48.7642C51.6231 51.1218 55.1948 55.0471 57.3991 60.3634L56.3028 60.8114ZM13.2891 46.7956V45.6169C13.3952 45.6169 15.906 45.5343 17.8981 42.1277L18.9119 42.7171C16.5661 46.7485 13.4187 46.7956 13.2891 46.7956Z" fill="#8AC6FF"/>
                    <path d="M23.9581 53.5974C15.1172 53.5974 8.18597 50.0257 7.87949 49.8607C7.70267 49.7664 7.58479 49.5896 7.56121 49.3892C7.53764 49.1888 7.63194 49.0002 7.78518 48.8705C8.0563 48.6583 14.5278 43.7192 25.5612 43.7192C36.7596 43.7192 39.3058 48.8705 39.4119 49.0827C39.5298 49.3302 39.4591 49.6367 39.2351 49.8018C39.0583 49.9432 34.7557 53.1731 25.2665 53.5621C24.8304 53.5974 24.3942 53.5974 23.9581 53.5974ZM9.34118 49.2477C11.628 50.2615 17.9345 52.6898 25.2312 52.3951C32.6339 52.0886 36.7832 49.9668 38.0799 49.177C37.7498 48.7291 37.0897 47.9982 35.9345 47.2792C34.2135 46.2065 31.019 44.9216 25.573 44.9216C17.1329 44.9098 11.3923 47.9629 9.34118 49.2477Z" fill="#8AC6FF"/>
                  </svg>''',
                            svgHeight: 60,
                            svgWeight: 60.354,
                            gap: 24,
                          ),
                          getWorkoutGoalCard(
                            context: context,
                            title: 'Keep Fit',
                            svg:
                                '''<svg xmlns="http://www.w3.org/2000/svg" width="83" height="79" viewBox="0 0 83 79" fill="none">
                    <path d="M55.4348 60.0747V50.2332C55.4348 49.5587 55.657 48.9004 56.0803 48.3756C59.1644 44.5527 60.5745 40.4368 61.3439 36.9325C63.9403 36.902 66.2357 36.7024 68.2558 36.3917M37.1539 18.4776V22.5533C33.508 24.5138 29.3905 23.445 25.7173 24.8213C25.2311 25.0032 24.6935 24.9774 24.2219 24.7585C18.786 22.2458 14.1051 23.0796 10.7458 25.375C10.3337 25.6567 9.7832 25.3267 9.84597 24.8325L10.2854 21.3798C10.4523 20.0652 10.9285 18.8088 11.6751 17.7139C12.4216 16.619 13.4172 15.7168 14.58 15.0812L15.9482 14.3343C15.9482 14.3343 19.6392 15.2212 21.9651 14.3601C22.5221 14.154 22.8343 13.5601 22.7088 12.9806C22.1325 10.3311 19.8999 5.49728 18.9196 5.57615C17.8106 5.66468 10.4158 7.86509 9.05402 9.99789C7.2351 12.8438 3.69384 19.1118 1.54333 29.3798C1.39685 30.0752 1.62704 30.8012 2.1534 31.2792C4.06085 33.0145 9.58521 36.7875 21.6561 36.9324C22.4255 40.4366 23.8356 44.5525 26.9197 48.3755C27.343 48.9002 27.5651 49.5586 27.5651 50.233V60.0745M45.8461 18.4776V22.5533C49.492 24.5138 53.6095 23.445 57.2827 24.8213C57.7689 25.0032 58.3065 24.9774 58.7781 24.7585C64.2139 22.2458 68.8948 23.0796 72.2542 25.375C72.6663 25.6567 73.2168 25.3267 73.154 24.8325L72.7146 21.3798C72.5477 20.0652 72.0715 18.8088 71.3249 17.7139C70.5784 16.619 69.5828 15.7168 68.42 15.0812L67.0518 14.3343C67.0518 14.3343 63.3608 15.2212 61.0349 14.3601C60.4779 14.154 60.1656 13.5601 60.2912 12.9806C60.8675 10.3311 63.1001 5.49728 64.0803 5.57615C65.1894 5.66468 72.5842 7.86509 73.946 9.99789C75.7649 12.8438 79.3062 19.1118 81.4567 29.3798C81.6031 30.0752 81.373 30.8012 80.8466 31.2792C79.773 32.2563 77.5564 33.8756 73.6723 35.1328" stroke="#8AC6FF" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M34.494 4.75111C33.9777 5.75715 33.7306 6.91917 33.8441 8.1372L34.4844 15.006C34.6811 17.1169 36.4527 18.7309 38.5726 18.7309H44.4284C46.5485 18.7309 48.3199 17.1169 48.5166 15.006L49.1569 8.1372C49.4945 4.51675 46.6457 1.39014 43.0095 1.39014H39.9914C39.6244 1.38997 39.2582 1.42224 38.897 1.48656M13.3262 36.1486C16.3514 36.7271 20.0608 37.0546 24.5747 36.8996M58.4265 36.8998C61.2589 36.997 63.7746 36.9041 66.0034 36.6786M37.8933 28.0154C39.8856 28.0154 41.5006 29.6304 41.5006 31.6227M41.5006 31.6227V34.9062M41.5006 31.6227C41.5006 29.6304 43.1156 28.0154 45.1078 28.0154M41.5006 47.91V54.1937M36.7566 40.3287C36.7566 43.2584 34.862 45.7459 32.2313 46.6325M46.2446 40.3287C46.2446 43.2584 48.1392 45.7459 50.7698 46.6325M39.3797 77.6098L39.7337 74.0468C39.7995 73.6254 40.0137 73.2414 40.3377 72.9641C40.6617 72.6868 41.0741 72.5343 41.5006 72.5343C41.9271 72.5343 42.3395 72.6868 42.6635 72.9641C42.9875 73.2414 43.2017 73.6254 43.2675 74.0468L43.6215 77.6098" stroke="#8AC6FF" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M57.0508 77.6096L55.4344 62.368V60.0747H27.5656V62.368L25.9492 77.6096" stroke="#8AC6FF" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>''',
                            svgHeight: 75,
                            svgWeight: 76.22,
                            gap: 9,
                          ),
                          getWorkoutGoalCard(
                            context: context,
                            title: 'Lose Weight',
                            svg:
                                '''<svg xmlns="http://www.w3.org/2000/svg" width="61" height="64" viewBox="0 0 61 64" fill="none">
                    <path d="M18.5295 28.3438L19.8279 29.9676L23.7262 26.8489C23.8477 26.7513 23.9457 26.6277 24.013 26.4872C24.0803 26.3466 24.1153 26.1928 24.1153 26.037C24.1153 25.8812 24.0803 25.7274 24.013 25.5868C23.9457 25.4463 23.8477 25.3227 23.7262 25.2251L19.8279 22.1064L18.5295 23.7302L20.1138 24.9974H9.71094V27.0766H20.1127L18.5295 28.3438ZM41.1762 29.9676L42.4756 28.3438L40.8914 27.0766H51.2931V24.9974H40.8914L42.4756 23.7302L41.1762 22.1064L37.2779 25.2251C37.1564 25.3227 37.0584 25.4463 36.9911 25.5868C36.9237 25.7274 36.8888 25.8812 36.8888 26.037C36.8888 26.1928 36.9237 26.3466 36.9911 26.4872C37.0584 26.6277 37.1564 26.7513 37.2779 26.8489L41.1762 29.9676Z" fill="white"/>
                    <path d="M50.9211 34.5374L50.4876 33.871L48.1008 29.3178L46.1589 30.0559L48.6923 34.9137L49.1757 35.6653C49.4335 36.0645 49.6872 36.4585 49.9356 36.8504C49.5416 37.2995 44.6162 42.6698 35.1802 42.6698H24.7846C17.227 42.6698 12.5345 39.1852 10.7818 37.5906C11.155 36.9783 11.5386 36.3732 11.9201 35.7786L14.5772 31.0798L14.623 30.9873C14.8361 30.5018 15.0325 30.0122 15.2165 29.5163L13.2674 28.7938C13.1031 29.2357 12.9285 29.6723 12.7403 30.1047L10.1705 34.6559C9.184 36.1913 8.1642 37.7798 7.37933 39.5106C5.82312 42.9807 5.22434 46.8644 5.08815 50.6962C5.07984 50.7243 5.06009 50.7461 5.05489 50.7752C5.02594 50.9251 5.03055 51.0796 5.0684 51.2274C4.97068 55.1705 5.34596 59.0355 5.66407 62.3081L5.67758 62.4224L6.71714 62.4214H7.75669C7.75579 62.3076 7.74711 62.194 7.7307 62.0814C7.44794 59.1738 7.12152 55.7734 7.13712 52.2971C11.207 53.2774 23.9467 56.7163 29.2121 62.464C29.4733 62.753 29.7921 62.9841 30.148 63.1424C30.5039 63.3008 30.889 63.3828 31.2786 63.3833C31.6681 63.3838 32.0535 63.3027 32.4098 63.1453C32.7661 62.9879 33.0855 62.7575 33.3474 62.4692C38.3165 57.0448 49.6986 53.6506 54.0356 52.5144C54.0377 55.9106 53.7186 59.2227 53.442 62.0565L53.4119 62.2956L55.4744 62.5472L55.5076 62.2821C56.1469 55.7152 57.0233 46.7189 53.7809 39.5117C52.9846 37.734 51.9357 36.1092 50.9211 34.5374ZM31.8099 61.0689C31.7427 61.1432 31.6605 61.2025 31.5688 61.2429C31.4771 61.2834 31.378 61.3041 31.2778 61.3037C31.1776 61.3033 31.0786 61.2818 30.9872 61.2406C30.8959 61.1995 30.8142 61.1395 30.7475 61.0648C24.8168 54.5904 10.9045 51.0278 7.19014 50.1702C7.35854 46.7636 7.92822 43.3663 9.2734 40.3662C9.41374 40.0574 9.56968 39.7539 9.72665 39.4503C11.9451 41.3808 16.9328 44.75 24.7825 44.75H35.1781C44.1941 44.75 49.4377 40.308 51.0375 38.707C51.34 39.2486 51.628 39.7965 51.8827 40.3631C53.2611 43.4277 53.8287 46.9039 53.9857 50.3781C49.2921 51.5663 37.2957 55.0811 31.8099 61.0689ZM46.1194 21.7321C45.084 14.5093 48.0176 6.77398 50.6602 1.55854L48.8067 0.618778C46.0279 6.10139 42.9488 14.2671 44.0611 22.0274L46.1194 21.7321ZM15.0377 21.754L17.1013 22.0035C18.0514 14.1652 14.9577 6.0463 12.1956 0.616699L10.3431 1.55854C12.9742 6.7324 15.9245 14.4345 15.0377 21.754Z" fill="white"/>
                    <path d="M28.4224 30.1954H30.5016V33.3141H28.4224V30.1954ZM6.93692 18.5482L6.77268 18.6802C6.69055 18.7457 6.60843 18.8143 6.5211 18.8778L6.49927 18.8965C6.17827 19.0934 5.87743 19.3215 5.6011 19.5774L7.01593 21.1003C7.21014 20.9185 7.42345 20.7581 7.65214 20.6221L7.74466 20.5494L7.74882 20.5546C7.86317 20.4714 7.97336 20.382 8.08148 20.2947L8.24053 20.1668C8.3923 20.041 8.53472 19.9132 8.66363 19.7801L7.1729 18.331C7.09803 18.4074 7.01927 18.4799 6.93692 18.5482ZM7.55546 17.2457C7.56793 17.3247 7.57417 17.4016 7.57417 17.4764H9.65328C9.65305 17.2919 9.63845 17.1077 9.60962 16.9255C9.49839 16.1936 9.08776 15.6042 8.78733 15.2258L7.15627 16.5149C7.39953 16.8226 7.52635 17.0523 7.55546 17.2457ZM4.41496 9.50825C4.46367 10.1347 4.54661 10.7579 4.66342 11.3753L6.70614 10.9855C6.60389 10.4437 6.53101 9.89677 6.48784 9.34712L4.41496 9.50825ZM5.75703 14.6748C5.82148 14.8079 5.89841 14.9389 5.98261 15.0688L7.72387 13.9336C7.68647 13.8768 7.65246 13.8178 7.62199 13.7569C7.42876 13.365 7.2607 12.9612 7.11885 12.5479L5.15409 13.2267C5.32665 13.7299 5.53041 14.2185 5.75703 14.6748ZM6.00444 22.4216L4.18522 21.4164C3.82507 22.0741 3.54449 22.7724 3.34942 23.4965L5.35472 24.0443C5.51585 23.458 5.73416 22.9112 6.00444 22.4216ZM2.90865 57.3153L0.836816 57.492C0.900229 58.2239 0.965721 58.8996 1.02809 59.5036L3.09577 59.2884C3.03444 58.6948 2.96998 58.0326 2.90865 57.3153ZM1.75682 39.2146L3.74445 39.8238C3.93885 39.1917 4.16027 38.6116 4.40457 38.1012L2.52817 37.2062C2.22225 37.8558 1.96444 38.5271 1.75682 39.2146ZM2.63525 35.5429L2.84524 33.5563L4.91187 33.7746L4.70188 35.7612L2.63525 35.5429ZM2.65396 53.366L0.576927 53.4554C0.607074 54.1509 0.643459 54.8256 0.68608 55.4743L2.76103 55.3402C2.71945 54.706 2.68307 54.0459 2.65396 53.366ZM5.11666 27.6038C5.04166 27.0081 5.02391 26.4065 5.06365 25.8074L2.98869 25.6713C2.94108 26.4032 2.96301 27.138 3.05419 27.8658L5.11666 27.6038ZM2.57911 50.0301L2.58119 49.423L0.502079 49.4022L0.5 50.0332C0.5 50.5031 0.504158 50.9688 0.513514 51.4314L2.59262 51.393C2.5834 50.9387 2.57889 50.4844 2.57911 50.0301ZM2.75272 45.5028L0.680883 45.3303C0.624626 46.0088 0.582688 46.6885 0.555096 47.3688L2.63213 47.4562C2.6585 46.8043 2.69871 46.153 2.75272 45.5028ZM3.05835 31.5686L3.26834 29.58L5.33497 29.7983L5.12498 31.787L3.05835 31.5686ZM3.27977 41.6658L1.24328 41.2479C1.10532 41.925 0.990898 42.6067 0.900229 43.2917L2.96063 43.5682C3.04795 42.9144 3.15398 42.2781 3.27977 41.6658ZM54.4342 17.2353C54.4612 17.0502 54.5891 16.8194 54.8365 16.5086L53.2054 15.2175C52.878 15.6323 52.4871 16.2009 52.379 16.9172C52.3494 17.0986 52.3341 17.2822 52.3333 17.466H54.4124C54.4124 17.3954 54.4196 17.3215 54.4342 17.2353ZM57.4208 10.8119C57.4874 10.3794 57.5393 9.93863 57.5726 9.49578L55.4997 9.33984C55.4581 9.88782 55.3859 10.433 55.2835 10.973L57.3242 11.3691C57.3605 11.1819 57.3928 10.9959 57.4208 10.8119ZM56.2285 14.679C56.4593 14.2122 56.664 13.7195 56.8366 13.2153L54.8687 12.5417C54.7267 12.9574 54.5583 13.3637 54.3645 13.758C54.334 13.82 54.2997 13.8801 54.2616 13.9378L56.0174 15.0501C56.0964 14.9275 56.1671 14.8027 56.2285 14.679ZM55.4675 18.8778C55.3781 18.8123 55.2929 18.7426 55.2097 18.675L55.0704 18.5638C54.9806 18.4913 54.8952 18.4136 54.8147 18.331L53.324 19.7811C53.4529 19.9142 53.5942 20.0421 53.7647 20.1824L53.8999 20.2905C54.0101 20.3799 54.1223 20.4704 54.2388 20.5556L54.2429 20.5504L54.3365 20.6221C54.5558 20.7521 54.77 20.9132 54.9716 21.1003L56.3865 19.5774C56.1112 19.3218 55.811 19.0944 55.4904 18.8986L55.4675 18.8778ZM56.6308 24.0371L58.6371 23.4892C58.4423 22.7654 58.1609 22.0677 57.7992 21.4112L55.9821 22.4206C56.2524 22.9081 56.4717 23.4528 56.6308 24.0371ZM58.4209 49.4542C58.4125 50.109 58.3942 50.7637 58.3658 51.4179L60.4428 51.5073C60.4719 50.8378 60.4917 50.1601 60.5 49.4791L58.4209 49.4542ZM58.0986 55.3485L60.1694 55.5356C60.2276 54.89 60.2817 54.2164 60.3295 53.5241L58.2546 53.3816C58.2111 54.0379 58.1591 54.6936 58.0986 55.3485ZM56.9447 26.4239C56.9447 26.8137 56.9208 27.2067 56.874 27.5913L58.9365 27.845C59.0264 27.1198 59.0473 26.3878 58.9989 25.6588L56.9239 25.797C56.9374 26.0029 56.9447 26.2129 56.9447 26.4239ZM58.4115 47.4936L60.4906 47.4489C60.4759 46.7681 60.4465 46.0877 60.4023 45.4082L58.3273 45.5465C58.3699 46.189 58.398 46.8397 58.4115 47.4936ZM58.1496 43.6161L60.212 43.3624C60.1293 42.6767 60.0211 41.9943 59.8877 41.3166L57.8491 41.723C57.9656 42.3052 58.0664 42.9424 58.1496 43.6161ZM59.3762 39.2759C59.2733 38.9438 59.1586 38.6154 59.0322 38.2915L59.0041 37.6137L56.927 37.701L56.9697 38.7364L57.0372 38.9038C57.1661 39.2198 57.2836 39.5504 57.3928 39.8955L59.3762 39.2759ZM57.6579 59.2738L59.7183 59.5483C59.7983 58.9474 59.8825 58.2738 59.9646 57.5461L57.898 57.3122C57.819 58.0264 57.7369 58.6844 57.6579 59.2738ZM56.7524 33.7091L58.8294 33.6239L58.9126 35.6177L56.8345 35.703L56.7524 33.7091ZM56.5892 29.7224L58.6662 29.6351L58.7494 31.6289L56.6734 31.7163L56.5892 29.7224Z" fill="white"/>
                  </svg>''',
                            svgHeight: 60,
                            svgWeight: 62.767,
                            gap: 22,
                          ),
                        ],
                      ),
                      const Gap(32),
                      if (createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .goalType
                              ?.toLowerCase() ==
                          'Lose Weight'.toLowerCase())
                        const Text(
                          'Wight Goal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .goalType
                              ?.toLowerCase() ==
                          'Lose Weight'.toLowerCase())
                        const Gap(16),
                      if (createWorkoutPlanController
                              .createWorkoutPlanModel
                              .value
                              .goalType
                              ?.toLowerCase() ==
                          'Lose Weight'.toLowerCase())
                        TextFormField(
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          decoration: getTextInputDecoration(
                            context,
                            hintText: 'Weight want to lose',
                          ).copyWith(suffixText: ('kg')),
                          validator: (value) {
                            if (double.tryParse(value ?? '') != null) {
                              return null;
                            } else {
                              return 'Please enter a valid weight';
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                    ],
                  ),
                ),
              ),
              const Gap(20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (createWorkoutPlanController
                            .createWorkoutPlanModel
                            .value
                            .goalType !=
                        null) {
                      if (double.tryParse(textEditingController.text) != null) {
                        createWorkoutPlanController
                            .createWorkoutPlanModel
                            .value
                            .weightGoal = textEditingController.text;
                      }
                      widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                      log(
                        createWorkoutPlanController.createWorkoutPlanModel.value
                            .toJson(),
                        name: 'WorkOutPLan',
                      );
                    } else {
                      toastification.show(
                        context: context,
                        title: const Text('Please select workout goal'),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    }
                  },
                  child: const Text('NEXT '),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector getWorkoutGoalCard({
    required BuildContext context,
    required String title,
    required String svg,
    double? svgHeight,
    double? svgWeight,
    double? gap,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          createWorkoutPlanController.createWorkoutPlanModel.value.goalType =
              title;
        });
      },
      child: Container(
        height: 120,
        width: 95,
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color:
              createWorkoutPlanController.createWorkoutPlanModel.value.goalType
                          ?.toLowerCase() ==
                      title.toLowerCase()
                  ? MyAppColors.third
                  : MyAppColors.transparentGray,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: svgHeight,
              width: svgWeight,
              child: SvgPicture.string(
                svg,
                color:
                    createWorkoutPlanController
                                .createWorkoutPlanModel
                                .value
                                .goalType
                                ?.toLowerCase() ==
                            title.toLowerCase()
                        ? MyAppColors.primary
                        : const Color(0xff8AC6FF),
              ),
            ),
            Gap(gap ?? 0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color:
                    createWorkoutPlanController
                                .createWorkoutPlanModel
                                .value
                                .goalType
                                ?.toLowerCase() ==
                            title.toLowerCase()
                        ? MyAppColors.primary
                        : const Color(0xff8AC6FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
BMI Category
1. Underweight -> Below 18.5
2. Healthy Weight -> 18.5 to 24.9
3. Overweight -> 25.0 to 29.9
4. Obesity -> 30.0 or greater
5. Obesity Class I -> 30.0 to 34.9
6. Obesity Class II -> 35.0 to 39.9
7. Obesity Class III -> 40.0 or greater
*/

enum BMICategory {
  underweight,
  healthyWeight,
  overweight,
  obesity,
  obesityClassI,
  obesityClassII,
  obesityClassIII,
}

BMICategory getBMICategory(double bmi) {
  if (bmi < 18.5) {
    return BMICategory.underweight;
  } else if (bmi >= 18.5 && bmi < 24.9) {
    return BMICategory.healthyWeight;
  } else if (bmi >= 25.0 && bmi < 29.9) {
    return BMICategory.overweight;
  } else if (bmi >= 30.0 && bmi < 34.9) {
    return BMICategory.obesityClassI;
  } else if (bmi >= 35.0 && bmi < 39.9) {
    return BMICategory.obesityClassII;
  } else {
    return BMICategory.obesityClassIII;
  }
}
