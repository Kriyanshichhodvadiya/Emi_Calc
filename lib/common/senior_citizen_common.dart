import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';

Widget seniorCitizenRow(
    {required String label, required String text, double fontSize = 14}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: style(
            color: AppColors.black.withOpacity(0.4),
            fontSize: fontSize,
            fontWeight: FontWeight.w600),
      ),
      Text(
        text,
        style: style(
            color: AppColors.black.withOpacity(0.4),
            fontSize: fontSize,
            fontWeight: FontWeight.w600),
      ),
    ],
  );
}
