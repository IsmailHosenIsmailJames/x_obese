import "package:flutter/material.dart";
import "package:x_obese/src/theme/colors.dart";

InputDecoration getTextInputDecoration(
  BuildContext context, {
  String? hintText,
  String? labelText,
}) {
  return InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: MyAppColors.transparentGray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: MyAppColors.transparentGray),
    ),

    hintText: hintText,
    labelText: labelText,
    hintStyle: TextStyle(color: MyAppColors.mutedGray),
  );
}
