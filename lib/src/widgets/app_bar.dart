import "package:flutter/cupertino.dart";
import "package:flutter_svg/flutter_svg.dart";

Widget getAppBar({
  required Widget backButton,
  required String title,
  bool showLogo = false,
  bool isWhite = false,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      backButton,
      Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 30,
        width: 50,
        child: showLogo ? SvgPicture.asset("assets/img/x_blue.svg") : null,
      ),
    ],
  );
}
