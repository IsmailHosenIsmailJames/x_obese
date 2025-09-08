import "dart:developer";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:shimmer/shimmer.dart";
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

mixin PaginationController<T extends StatefulWidget> on State<T> {
  void addPaginationListener({
    required ScrollController controller,
    required Future<void> Function() onFetch,
    required ValueGetter<bool> isLoading,
    required ValueSetter<bool> setLoading,
    double threshold = 0.9,
  }) {
    controller.addListener(() async {
      if (controller.position.hasContentDimensions &&
          !isLoading() &&
          controller.position.pixels >=
              controller.position.maxScrollExtent * threshold) {
        if (!mounted) return;
        setLoading(true);
        try {
          await onFetch();
        } finally {
          if (mounted) {
            setLoading(false);
          }
        }
      }
    });
  }
}

class MarathonPage extends StatefulWidget {
  final PageController pageController;
  const MarathonPage({super.key, required this.pageController});

  @override
  State<MarathonPage> createState() => _MarathonPageState();
}

class _MarathonPageState extends State<MarathonPage> with PaginationController<MarathonPage> {
  int selectedIndex = 0;
  PageController pageController = PageController();
  AllInfoController allInfoController = Get.find();

  ScrollController scrollControllerVirtual = ScrollController();
  ScrollController scrollControllerOnsite = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    addPaginationListener(
      controller: scrollControllerVirtual,
      onFetch: _getMoreMarathonData,
      isLoading: () => _isLoading,
      setLoading: (loading) => setState(() => _isLoading = loading),
    );
    addPaginationListener(
      controller: scrollControllerOnsite,
      onFetch: _getMoreMarathonData,
      isLoading: () => _isLoading,
      setLoading: (loading) => setState(() => _isLoading = loading),
    );
  }

  @override
  void dispose() {
    scrollControllerVirtual.dispose();
    scrollControllerOnsite.dispose();
    pageController.dispose();
    super.dispose();
  }

  Future<void> _getMoreMarathonData() async {
    DioClient dioClient = DioClient(baseAPI);
    final page = ((allInfoController.marathonList.value?.length ?? 0) / 10).ceil() + 1;
    log("try to get more marathon info -> page $page");
    try {
      final response = await dioClient.dio.get(
        "/api/marathon/v1/marathon?page=$page&size=10",
      );
      printResponse(response);
      if (response.statusCode == 200) {
        List marathonListData = response.data["data"];
        if (marathonListData.isEmpty) {
          return;
        }

        final newMarathons = marathonListData
            .map((data) => MarathonModel.fromMap(data))
            .toList();
        allInfoController.marathonList.value = [
          ...allInfoController.marathonList.value ?? [],
          ...newMarathons,
        ];
      }
    } on DioException catch (e) {
      log(e.message ?? "", name: "Error");
      if (e.response != null) {
        printResponse(e.response!);
      }
    }
  }

  Widget _buildMarathonItemShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 250,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ));
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
                      backgroundColor: selectedIndex == 0
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
                      backgroundColor: selectedIndex == 1
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
                Obx(() {
                  final allMarathons = allInfoController.marathonList.value;
                  if (allMarathons == null) {
                    return ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) =>
                          _buildMarathonItemShimmer(),
                    );
                  }
                  final virtualMarathons =
                      allMarathons.where((m) => m.type == "virtual").toList();
                  if (virtualMarathons.isEmpty) {
                    return Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MyAppColors.transparentGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.run_circle_outlined,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                          const Gap(5),
                          Text(
                            "Exciting Marathon Events Coming Near You Soon! Stay Tuned.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollControllerVirtual,
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 15,
                      right: 15,
                    ),
                    itemCount: virtualMarathons.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= virtualMarathons.length) {
                        return _buildMarathonItemShimmer();
                      }
                      return SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: getMarathonCard(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          marathonData: virtualMarathons[index],
                          context: context,
                          margin: const EdgeInsets.only(top: 20),
                        ),
                      );
                    },
                  );
                }),
                Obx(() {
                  final allMarathons = allInfoController.marathonList.value;
                  if (allMarathons == null) {
                    return ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) =>
                          _buildMarathonItemShimmer(),
                    );
                  }
                  final onsiteMarathons =
                      allMarathons.where((m) => m.type != "virtual").toList();
                  if (onsiteMarathons.isEmpty) {
                    return Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MyAppColors.transparentGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.run_circle_outlined,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                          const Gap(5),
                          Text(
                            "Exciting Marathon Events Coming Near You Soon! Stay Tuned.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollControllerOnsite,
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 15,
                      right: 15,
                    ),
                    itemCount: onsiteMarathons.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= onsiteMarathons.length) {
                        return _buildMarathonItemShimmer();
                      }
                      return getOnsiteMarathon(
                        context: context,
                        marathonData: onsiteMarathons[index],
                        margin: const EdgeInsets.only(top: 20),
                      );
                    },
                  );
                }),
              ],
            ),
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
                            builder: (context) => ShowSearchResult(
                              marathonUserList: searchResult
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
                          title: e.response?.data["message"] ??
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