import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';

Widget recentCalText({required String text}) {
  return Text(
    text,
    style: style(fontSize: 14, fontWeight: FontWeight.w600),
  );
}

Widget recentCalLabel({required String label}) {
  return Text(
    label,
    style: style(
      color: AppColors.greytext,
      fontSize: 13,
      fontWeight: FontWeight.w400,
    ),
  );
}
