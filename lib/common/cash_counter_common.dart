import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/color.dart';
import 'common_widget.dart';

Widget countRow({
  required String rs,
  TextEditingController? controller,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
  required String rsTotal,
}) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Row(
          children: [
            Text(
              "Rs. " + "${rs}",
              style: style(
                  color: AppColors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
            Spacer(),
            Text(
              "x",
              style: style(
                  color: AppColors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ],
        ),
      ),
      20.width,
      Expanded(
        flex: 1,
        child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
            ],

            controller: controller,
            onChanged: onChanged,
            validator: validator,
            keyboardType: TextInputType.number,
            cursorColor: AppColors.black,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),

              hintText: "Note",
              labelText: "note",
              labelStyle: style(
                color: AppColors.black.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              hintStyle: style(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greytext),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.black),
                  borderRadius: BorderRadius.circular(5)),
            )),
      ),
      20.width,
      Expanded(
          flex: 3,
          child: Row(
            children: [
              Text(
                "=",
                style: style(
                    color: AppColors.black.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              Spacer(),
              Text(
                "${rsTotal}" + " ₹",
                style: style(
                    color: AppColors.black.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ],
          ))
    ],
  );
}
