import "dart:developer";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:toastification/toastification.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/marathon/components/onsite_marathon_card.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/screens/marathon/models/marathon_user_model.dart";
import "package:x_obese/src/screens/marathon/show_search_result/show_search_result.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:x_obese/src/screens/marathon/components/virtual_marathon_cards.dart";

int nextPageNumber = 2;

class MarathonPage extends StatefulWidget {
  final PageController pageController;
  const MarathonPage({super.key, required this.pageController});

  @override
  State<MarathonPage> createState() => _MarathonPageState();
}

// load more marathon data

bool isLoading = false;
Future<void> getMoreMarathonData() async {
  AllInfoController allInfoController = Get.find();

  DioClient dioClient = DioClient(baseAPI);
  log("try to get more marathon info -> $nextPageNumber");
  try {
    // get marathon programs
    final response = await dioClient.dio.get(
      "/api/marathon/v1/marathon?page=$nextPageNumber&size=10",
    );
    printResponse(response);
    if (response.statusCode == 200) {
      List marathonListData = response.data["data"];
      if (marathonListData.isEmpty) {
        return;
      }
      nextPageNumber++;

      for (var marathon in marathonListData) {
        allInfoController.marathonList.add(MarathonModel.fromMap(marathon));
      }
    }
  } on DioException catch (e) {
    log(e.message ?? "", name: "Error");
    if (e.response != null) {
      printResponse(e.response!);
    }
  }
}

class _MarathonPageState extends State<MarathonPage> {
  int selectedIndex = 0;
  PageController pageController = PageController();
  AllInfoController allInfoController = Get.find();

  ScrollController scrollControllerVirtual = ScrollController();
  ScrollController scrollControllerOnsite = ScrollController();

  @override
  void initState() {
    log("Marathon page init state");
    scrollControllerOnsite.addListener(() async {
      if (scrollControllerOnsite.position.pixels ==
          scrollControllerOnsite.position.maxScrollExtent) {
        setState(() {
          isLoading = false;
        });
        await getMoreMarathonData();
        setState(() {
          isLoading = false;
        });
      }
    });
    scrollControllerVirtual.addListener(() async {
      if (scrollControllerVirtual.position.pixels ==
          scrollControllerVirtual.position.maxScrollExtent) {
        setState(() {
          isLoading = false;
        });
        await getMoreMarathonData();
        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
            child: Row(
              children: [
                getBackButton(
                  context,
                  () => widget.pageController.jumpToPage(0),
                ),
                const Spacer(),
                const Text(
                  "Marathon Program",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    TextEditingController textEditingController =
                        TextEditingController();
                    searchWidgetPopup(context, textEditingController);
                  },
                  icon: SvgPicture.string(
                    '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M22 22L20 20M2 11.5C2 6.25329 6.25329 2 11.5 2C16.7467 2 21 6.25329 21 11.5C21 16.7467 16.7467 21 11.5 21C6.25329 21 2 16.7467 2 11.5Z" stroke="#28303F" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>''',
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),

          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: MyAppColors.third,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedIndex == 0
                              ? MyAppColors.primary
                              : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      foregroundColor:
                          selectedIndex == 0 ? MyAppColors.third : Colors.white,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      pageController.jumpToPage(0);
                    },
                    child: const Text(" Virtual Marathon "),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedIndex == 1
                              ? MyAppColors.primary
                              : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      foregroundColor:
                          selectedIndex == 1 ? MyAppColors.third : Colors.white,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      pageController.jumpToPage(1);
                    },
                    child: const Text(" Onsite marathon "),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              children: [
                Obx(
                  () => ListView.builder(
                    controller: scrollControllerVirtual,
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 15,
                      right: 15,
                    ),
                    itemCount: allInfoController.marathonList.length,
                    itemBuilder: (context, index) {
                      if (allInfoController.marathonList[index].type ==
                          "virtual") {
                        return SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: getMarathonCard(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            marathonData: allInfoController.marathonList[index],
                            context: context,
                            margin: const EdgeInsets.only(top: 20),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                Obx(
                  () => ListView.builder(
                    controller: scrollControllerOnsite,
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 15,
                      right: 15,
                    ),
                    itemCount: allInfoController.marathonList.length,
                    itemBuilder: (context, index) {
                      if (allInfoController.marathonList[index].type !=
                          "virtual") {
                        return getOnsiteMarathon(
                          context: context,
                          marathonData: allInfoController.marathonList[index],
                          margin: const EdgeInsets.only(top: 20),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            LinearProgressIndicator(
              color: MyAppColors.third,
              backgroundColor: MyAppColors.primary,
            ),
        ],
      ),
    );
  }

  Future<dynamic> searchWidgetPopup(
    BuildContext context,
    TextEditingController textEditingController,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: textEditingController,
                  autofocus: true,
                  keyboardType: TextInputType.webSearch,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: MyAppColors.mutedGray),
                    ),
                  ),
                ),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        String searchText = textEditingController.text;
                        DioClient dioClient = DioClient(baseAPI);
                        final response = await dioClient.dio.get(
                          "/api/marathon/v1/user?search=$searchText",
                        );
                        Navigator.pop(context);
                        printResponse(response);
                        List searchResult = response.data["data"];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ShowSearchResult(
                                  marathonUserList:
                                      searchResult
                                          .map(
                                            (e) => MarathonUserModel.fromMap(
                                              Map<String, dynamic>.from(e),
                                            ),
                                          )
                                          .toList(),
                                ),
                          ),
                        );
                      } on DioException catch (e) {
                        toastification.show(
                          context: context,
                          title:
                              e.response?.data["message"] ??
                              "Something went wrong",
                          type: ToastificationType.error,
                        );
                      }
                    },
                    label: const Text("Search"),
                    icon: SvgPicture.string(
                      '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                  <path d="M22 22L20 20M2 11.5C2 6.25329 6.25329 2 11.5 2C16.7467 2 21 6.25329 21 11.5C21 16.7467 16.7467 21 11.5 21C6.25329 21 2 16.7467 2 11.5Z" stroke="#28303F" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>''',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
