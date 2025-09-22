import "dart:developer";

import "package:cached_network_image/cached_network_image.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:intl/intl.dart";
import "package:url_launcher/url_launcher.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/activity/workout_page.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/marathon/details_marathon/model/full_marathon_data_model.dart";
import "package:x_obese/src/screens/marathon/leader_board/leader_board_view.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/screens/marathon/models/marathon_user_model.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:x_obese/src/widgets/popup_for_signup.dart";

class MarathonDetailsView extends StatefulWidget {
  final MarathonModel marathonData;
  final bool isVirtual;
  const MarathonDetailsView({
    super.key,
    required this.isVirtual,
    required this.marathonData,
  });

  @override
  State<MarathonDetailsView> createState() => _MarathonDetailsViewState();
}

class _MarathonDetailsViewState extends State<MarathonDetailsView> {
  FullMarathonDataModel? fullMarathonDataModel;

  @override
  void initState() {
    getSingleMarathonData();
    super.initState();
  }

  Future<void> getSingleMarathonData() async {
    DioClient dioClient = DioClient(baseAPI);
    try {
      final response = await dioClient.dio.get(
        "/api/marathon/v1/marathon/${widget.marathonData.id}",
      );
      printResponse(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          fullMarathonDataModel = FullMarathonDataModel.fromMap(response.data);
        });
      }
    } on DioException catch (e) {
      printResponse(e.response!);
    }
  }

  List<Alignment> profileAlignmentList = [
    Alignment.centerRight,
    Alignment.center,
    Alignment.centerLeft,
  ];

  AllInfoController allInfoController = Get.find<AllInfoController>();

  @override
  Widget build(BuildContext context) {
    final padding = const EdgeInsets.only(left: 15, right: 15, bottom: 15);
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 194,
                  width: double.infinity,
                  child:
                      widget.marathonData.imagePath == null
                          ? null
                          : CachedNetworkImage(
                            imageUrl: widget.marathonData.imagePath!,
                            fit: BoxFit.cover,
                          ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: getBackButton(context, () {
                      Navigator.pop(context);
                    }, size: const Size(40, 40)),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.transparent),
            Padding(
              padding: padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.marathonData.title ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(8),
                  GptMarkdown(
                    widget.marathonData.description ?? "",
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
                    style: TextStyle(color: MyAppColors.mutedGray),
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      SizedBox(
                        width:
                            (fullMarathonDataModel?.particiants!.length ?? 0) >
                                    0
                                ? 70
                                : 0,
                        height: 30,
                        child:
                            fullMarathonDataModel == null ||
                                    fullMarathonDataModel?.particiants == null
                                ? Container(
                                      height: 30,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: MyAppColors.third.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    )
                                    .animate(
                                      onPlay:
                                          (controller) => controller.repeat(),
                                    )
                                    .shimmer(
                                      duration: 1200.ms,
                                      color: const Color.fromARGB(
                                        255,
                                        163,
                                        231,
                                        255,
                                      ),
                                    )
                                : Stack(
                                  children: List.generate(
                                    profileAlignmentList.length,
                                    (index) {
                                      if (index >
                                          (fullMarathonDataModel
                                                      ?.particiants!
                                                      .length ??
                                                  0) -
                                              1) {
                                        return Container();
                                      }
                                      return Align(
                                        alignment: profileAlignmentList[index],
                                        child: Container(
                                          height: 30,
                                          width: 30,

                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 3,
                                              color: MyAppColors.primary,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            image:
                                                fullMarathonDataModel
                                                            ?.particiants?[index]
                                                            .imagePath ==
                                                        null
                                                    ? null
                                                    : DecorationImage(
                                                      image: CachedNetworkImageProvider(
                                                        fullMarathonDataModel!
                                                            .particiants![index]
                                                            .imagePath!,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                      ),
                      const Gap(10),
                      Text(
                        "${fullMarathonDataModel?.totalParticiants} Participants",
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
                    "About Challenge :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Gap(12),
                  GptMarkdown(
                    widget.marathonData.about ?? "",
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
                    style: TextStyle(color: MyAppColors.mutedGray),
                  ),
                  const Gap(24),
                  const Text(
                    "When :",
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Text(
                          "${DateFormat.yMMMMd().format(widget.marathonData.startDate!)}  TO  ${DateFormat.yMMMMd().format(widget.marathonData.endDate!)}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: MyAppColors.mutedGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  const Text(
                    "What you’ll get :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Gap(13),
                  if ((fullMarathonDataModel?.data?.rewards?.length ?? 0) == 0)
                    Text(
                      "Reword list is empty",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: MyAppColors.mutedGray,
                      ),
                    ),
                  ...List.generate(
                    fullMarathonDataModel?.data?.rewards?.length ?? 0,
                    (index) {
                      final currentReward =
                          fullMarathonDataModel?.data?.rewards?[index];
                      log(currentReward.toString(), name: "currentReward");
                      return Row(
                        children: [
                          SvgPicture.string(
                            '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M9 20V10C9 8.89543 9.89543 8 11 8H13C14.1046 8 15 8.89543 15 10V20M9 20C9 21.1046 9.89543 22 11 22H13C14.1046 22 15 21.1046 15 20M9 20V14C9 12.8954 8.10457 12 7 12H5C3.89543 12 3 12.8954 3 14V20C3 21.1046 3.89543 22 5 22H7C8.10457 22 9 21.1046 9 20ZM15 20V16C15 14.8954 15.8954 14 17 14H19C20.1046 14 21 14.8954 21 16V20C21 21.1046 20.1046 22 19 22H17C15.8954 22 15 21.1046 15 20Z" stroke="#AEA8A8" stroke-width="1.5"/>
          <path d="M11.5245 1.96353C11.6741 1.50287 12.3259 1.50287 12.4755 1.96353L12.6324 2.4463C12.6993 2.65232 12.8913 2.7918 13.1079 2.7918H13.6155C14.0999 2.7918 14.3013 3.4116 13.9094 3.6963L13.4988 3.99468C13.3235 4.122 13.2502 4.34768 13.3171 4.5537L13.474 5.03647C13.6237 5.49713 13.0964 5.88019 12.7046 5.59549L12.2939 5.29712C12.1186 5.1698 11.8814 5.1698 11.7061 5.29712L11.2954 5.59549C10.9036 5.88019 10.3763 5.49713 10.526 5.03647L10.6829 4.5537C10.7498 4.34768 10.6765 4.122 10.5012 3.99468L10.0906 3.6963C9.69871 3.4116 9.90009 2.7918 10.3845 2.7918H10.8921C11.1087 2.7918 11.3007 2.65232 11.3676 2.4463L11.5245 1.96353Z" fill="#AEA8A8"/>
        </svg>''',
                          ),
                          const Gap(10),
                          Text(
                            currentReward?["text"] ?? "",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: MyAppColors.mutedGray,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Gap(24),
                  if (!(fullMarathonDataModel?.data?.joined ?? false) ||
                      !widget.isVirtual)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        onPressed:
                            fullMarathonDataModel?.data?.joined == true
                                ? null
                                : () {
                                  if (fullMarathonDataModel == null ||
                                      (fullMarathonDataModel!.data?.joined ??
                                          false)) {
                                    return;
                                  }
                                  if (allInfoController.allInfo.value.isGuest) {
                                    showSignupPopup(context);
                                    return;
                                  }
                                  DioClient dioClient = DioClient(baseAPI);
                                  dioClient.dio
                                      .post(
                                        "/api/marathon/v1/user",
                                        data: {
                                          "marathonId":
                                              fullMarathonDataModel!.data!.id,
                                        },
                                      )
                                      .then((value) {
                                        printResponse(value);
                                        if (value.statusCode == 200 ||
                                            value.statusCode == 201) {
                                          setState(() {
                                            fullMarathonDataModel
                                                ?.data
                                                ?.joined = true;
                                          });
                                          log("Joined Successfully");
                                          Get.snackbar(
                                            "Success",
                                            "You have joined the challenge successfully",
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                          );
                                        }
                                      })
                                      .onError((error, stackTrace) {
                                        log(error.toString());
                                        Get.snackbar(
                                          "Error",
                                          error.toString(),
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      });
                                },
                        label: Text(
                          widget.isVirtual ? "Join Challenge" : "Register Now",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),

                  if ((fullMarathonDataModel?.data?.joined ?? false) &&
                      widget.isVirtual)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            DioClient dioClient = DioClient(baseAPI);
                            final response = await dioClient.dio.get(
                              "/api/marathon/v1/user/${fullMarathonDataModel?.data?.marathonUserId}",
                            );
                            final MarathonUserModel marathonUserModel =
                                MarathonUserModel.fromMap(
                                  response.data["data"],
                                );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ActivityPage(
                                      marathonData: fullMarathonDataModel,
                                      marathonUserModel: marathonUserModel,
                                    ),
                              ),
                            );
                          } on DioException catch (e) {
                            if (e.response != null) {
                              printResponse(e.response!);
                            }
                          }
                        },
                        child: const Text(
                          "Activity Now",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  if (fullMarathonDataModel?.data?.joined ?? false)
                    const Gap(24),
                  if ((fullMarathonDataModel?.data?.joined ?? false) &&
                      widget.isVirtual)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyAppColors.third,
                          foregroundColor: MyAppColors.primary,
                        ),
                        onPressed: () async {
                          try {
                            DioClient dioClient = DioClient(baseAPI);
                            final response = await dioClient.dio.get(
                              "/api/marathon/v1/user?marathonId=${fullMarathonDataModel?.data?.id}&size=1000&page=1",
                            );
                            printResponse(response);
                            if ((response.statusCode == 200 ||
                                    response.statusCode == 201) &&
                                response.data["success"]) {
                              List data = response.data["data"];
                              List<MarathonUserModel> marathonUserList = [];
                              for (Map user in data) {
                                marathonUserList.add(
                                  MarathonUserModel.fromMap(
                                    Map<String, dynamic>.from(user),
                                  ),
                                );
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => LeaderBoardView(
                                        title:
                                            fullMarathonDataModel
                                                ?.data
                                                ?.title ??
                                            "",
                                        leaderboardUsers: marathonUserList,
                                        marathonData: fullMarathonDataModel!,
                                      ),
                                ),
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: response.data["message"] ?? "",
                              );
                            }
                          } on DioException catch (e) {
                            log(e.message ?? "No Message");
                            if (e.response != null) {
                              Fluttertoast.showToast(
                                msg: e.response!.data["message"] ?? "",
                              );
                              printResponse(e.response!);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Something went wrong",
                              );
                            }
                          }
                        },
                        child: const Text(
                          "View Leaderboard",
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
