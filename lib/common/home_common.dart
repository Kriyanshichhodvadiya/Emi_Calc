import 'package:emi_calc/common/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/color.dart';

Widget EmicalContainer({
  required String label,
  required String img,
}) {
  return Container(
    height: 100,
    width: 100,
    decoration:commonDecoration(),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            img,
            height: 45,
            width: 45,
          ),
          5.height,
          Text(
            textAlign: TextAlign.center,
            label,
            style: style(fontWeight: FontWeight.w500, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}

Widget labeltext({
  required String text,
}) {
  return Text(
    text,
    style: style(fontWeight: FontWeight.w600, fontSize: 15),
  );
}
