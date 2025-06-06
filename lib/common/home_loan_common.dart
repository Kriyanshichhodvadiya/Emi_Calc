import 'package:flutter/material.dart';

import '../config/color.dart';
import 'common_widget.dart';

Widget HeaderText({
  required String label,
}) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Text(
      label,
      style: style(
          fontWeight: FontWeight.w500, color: AppColors.white, fontSize: 12),
      textAlign: TextAlign.center,
    ),
  );
}

Widget RowData({
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Text(
      text,
    ),
  );
}

Widget PaymentScheduleText({required String text, Color color = Colors.black}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,maxLines: 2,
      text,
      style: style(color: color),
    ),
  );
}
