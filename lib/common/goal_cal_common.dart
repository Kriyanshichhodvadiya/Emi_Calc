import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';

Widget labelColum({
  required String text,
  required String rs,
}) {
  return Column(
    children: [
      Text(
        text,
        style: style(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: AppColors.black.withOpacity(0.8)),
      ),
      3.height,
      Text(
        rs,
        style: style(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    ],
  );
}

Widget golDataRow({
  required String textRs,
  required String label,
  required String rs,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        textRs,
        style: style(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.black.withOpacity(0.8)),
      ),
      Container(
        // width: 100,
        padding: 5.symmetric,
        decoration: BoxDecoration(
          color: AppColors.bgcolor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: style(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Text(
        rs,
        style: style(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.black.withOpacity(0.8)),
      ),
    ],
  );
}
