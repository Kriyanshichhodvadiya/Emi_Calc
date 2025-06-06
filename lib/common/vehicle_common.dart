import 'package:emi_calc/common/common_widget.dart';
import 'package:flutter/material.dart';

import '../config/color.dart';

Widget dataRow({
  required String text,
  required String amount,
  double fontSize = 13,
}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          text,
          style: style(
              color: AppColors.textcolor,
              fontSize: fontSize,
              fontWeight: FontWeight.w400),
        ),
      ),
      Text(
        amount,
        style: style(
            color: AppColors.textcolor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400),
      ),
    ],
  );
}

Widget commonLabel({
  required String label,
}) {
  return Text(
    label,
    style: style(
        color: AppColors.black, fontSize: 14, fontWeight: FontWeight.w600),
  );
}


Widget selectYear({required backOnTap,required nextOnTap,required label}){
  return      Builder(
    builder: (context) {
      return Expanded(
        flex: 3,
        child: Container(
          height: 6.5.hp(context),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: backOnTap,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.black,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primarycolor,
                ),
              ),
              IconButton(
                onPressed: nextOnTap,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
}

Widget viewAllBtn({required onTap}){
  return Builder(
    builder: (context) {
      return Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 6.5.hp(context),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'View all',
                style: style(
                  color: AppColors.primarycolor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
    }
  );
}





