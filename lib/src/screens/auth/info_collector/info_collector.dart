import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/screens/auth/info_collector/model/all_info_model.dart';
import 'package:o_xbese/src/screens/auth/info_collector/pages/birth_date.dart';
import 'package:o_xbese/src/screens/auth/info_collector/pages/full_from.dart';
import 'package:o_xbese/src/screens/auth/info_collector/pages/gender.dart';
import 'package:o_xbese/src/screens/auth/info_collector/pages/height_weigth.dart';
import 'package:o_xbese/src/screens/auth/info_collector/pages/location.dart';
import 'package:o_xbese/src/screens/auth/info_collector/pages/name.dart';

import 'controller/controller.dart';

class InfoCollector extends StatefulWidget {
  final AllInfoModel initialData;
  const InfoCollector({super.key, required this.initialData});

  @override
  State<InfoCollector> createState() => _InfoCollectorState();
}

class _InfoCollectorState extends State<InfoCollector> {
  final AllInfoController allInfoController = Get.put(AllInfoController());
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    allInfoController.allInfo.value = widget.initialData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          NameCollectPage(pageController: pageController),
          GenderCollector(pageController: pageController),
          BirthDateCollector(pageController: pageController),
          HeightWeigthCollector(pageController: pageController),
          LocationCollector(pageController: pageController),
          FullFromInfoCollector(pageController: pageController),
        ],
      ),
    );
  }
}
