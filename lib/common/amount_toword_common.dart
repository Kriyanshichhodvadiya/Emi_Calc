import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/vehicle_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';

Widget countryAmount({
  required String countryname,
  required String amount,
  required String text,
}) {
  return Container(
    padding: 10.symmetric,
    width: double.maxFinite,
    decoration:commonDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          countryname,
          style: style(
              color: AppColors.textcolor,
              fontSize: 12,
              fontWeight: FontWeight.w700),
        ),
        5.height,
        Text(
          amount,
          style: style(
              color: AppColors.primarycolor,
              fontSize: 14,
              fontWeight: FontWeight.w700),
        ),
        Divider(
          height: 30,
          color: AppColors.greylight,
        ),
        Text(
          text,
          style: style(
              color: AppColors.black.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        10.height,
      ],
    ),
  );
}
