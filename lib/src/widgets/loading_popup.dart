import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:x_obese/src/theme/colors.dart';

Future<void> showLoadingPopUp(
  BuildContext context, {
  String? loadingText,
}) async {
  await showCupertinoDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: MyAppColors.third),
              if (loadingText != null) const Gap(10),
              if (loadingText != null)
                Text(
                  loadingText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
