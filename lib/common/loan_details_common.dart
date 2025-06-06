import 'package:flutter/material.dart';

import '../config/color.dart';
import 'common_widget.dart';

Widget subLabelTextLoan({
  required String text,
}) {
  return Text(
    text,
    style: style(
        fontWeight: FontWeight.w600,
        fontSize: 11,
        color: AppColors.black.withOpacity(0.5)),
  );
}

Widget labelTextLoan({
  required String label,
}) {
  return Text(
    label,
    style: style(
      color: AppColors.black.withOpacity(0.8),
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget chartText({
  required String text,
  Color? color,
}) {
  return Row(
    children: [
      Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
      5.width,
      Text(
        text,
        style: style(),
      )
    ],
  );
}

Widget CountRow({
  required String text,
  required String amount,
}) {
  return Padding(
    padding: 10.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: style(
            color: AppColors.black.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "${amount}" + " ₹",
          style: style(
            color: AppColors.black.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
