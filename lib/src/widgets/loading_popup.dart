import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:o_xbese/src/theme/colors.dart';

Future<void> showLoadingPopUp(BuildContext context) async {
  await showCupertinoDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(color: MyAppColors.third),
          ),
        ),
      );
    },
  );
}
