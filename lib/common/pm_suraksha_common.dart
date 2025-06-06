import 'package:emi_calc/common/common_widget.dart';
import 'package:flutter/material.dart';

import '../config/color.dart';

Widget NoticeRow({
  required String text,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primarycolor,
        ),
      ),
      5.width,
      Flexible(
        child: Text(
          text,
          style: style(
            fontSize: 14,
            color: AppColors.primarycolor,
          ),
        ),
      )
    ],
  );
}
