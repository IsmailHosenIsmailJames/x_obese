import "package:get/get.dart";

class NavsController extends GetxController {
  RxInt bottomNavIndex = 0.obs;

  void changeBottomNav(int val) {
    bottomNavIndex.value = val;
  }
}
