import 'package:flutter/material.dart';

import '../config/color.dart';
import 'common_widget.dart';

Widget rdCalRow({
  required String text,
  required String amount,
}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          text,
          style: style(
              color: AppColors.textcolor,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
      ),
      Text(
        amount,
        style: style(
            color: AppColors.textcolor,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    ],
  );
}
