import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/pm_suraksha_common.dart';
import 'package:emi_calc/common/senior_citizen_common.dart';
import 'package:emi_calc/common/vehicle_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/pm_surksha_controller.dart';

class PmSurksha extends StatelessWidget {
  PmSurksha({super.key});
  PmSurkshaController controller = Get.put(PmSurkshaController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "PM Suraksha Bima(Accident)"),
      body: SingleChildScrollView(
        child: Padding(
          padding: 10.horizontal,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                20.height,
                Obx(
                  () => TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: controller.yearController.value,
                    onChanged: (value) {
                      controller.year.value = value;
                      if (value.isNotEmpty) {
                        int? age = int.tryParse(value);
                        if (age == null || age <= 18 || age >= 70) {
                          controller.ageError.value =
                              'Age must be between 18 and 70 years.';
                        } else {
                          controller.ageError.value =
                              ''; // Clear the error if valid
                        }
                      } else {
                        controller.ageError.value = 'Please enter your Age';
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Age';
                      }
                      int? age = int.tryParse(value);
                      if (age == null || age <= 18 || age >= 70) {
                        return 'Age must be between 18 and 70 years.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter 18 to 70 Year",

                      labelText: "Your Age (Year)",
                      labelStyle: style(
                        color: AppColors.black.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: style(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greytext),

                      errorText: controller.ageError.value.isNotEmpty
                          ? controller.ageError.value
                          : null, // Bind error dynamically
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: controller.ageError.value.isNotEmpty
                                ? Colors.red
                                : Colors.grey,
                            width: 0.6),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.black.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.black),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
                20.height,
                seniorCitizenRow(
                    fontSize: 12,
                    label: "Life Insurance Cover:",
                    text: "2 Lacs ₹"),
                20.height,
                seniorCitizenRow(
                    fontSize: 12,
                    label: "Cover Avaliable Till:",
                    text: "70 Year of Age"),
                30.height,
                Row(
                  children: [
                    Expanded(
                      child: primarybutton(
                        color: AppColors.white,
                        text: "Calculate",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            log("loanAmount : ${controller.year.value}");
                            controller.calculateContribution();
                            // controller.yearController.value.clear();
                          }
                        },
                      ),
                    ),
                    10.width,
                    Expanded(
                      child: primarybutton(
                        color: AppColors.black,
                        backgroundColor: AppColors.white,
                        text: "clear",
                        onPressed: () {
                          controller.clear();
                        },
                      ),
                    ),
                  ],
                ),
                20.height,
                Obx(
                  () => Visibility(
                    visible: controller.isValueShow.value,
                    child: Container(
                      padding: 10.symmetric,
                      width: double.maxFinite,
                      decoration:commonDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child:
                                    commonLabel(label: "Yearly Contribution:"),
                              ),
                              commonLabel(label: "20 ₹"),
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(
                            () => dataRow(
                              text: "Contribution Period",
                              amount: "${controller.contributionPeriod.value}",
                            ),
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(
                            () => dataRow(
                              text: "Total Contribution",
                              amount:
                                  "${controller.totalContribution.value.toStringAsFixed(0)} ₹",
                            ),
                          ),
                          20.height,
                          NoticeRow(
                              text:
                                  "You need to pay the premium amount 20/- every year to get life insurance cover of 2 Lacs/-."),
                          10.height,
                          NoticeRow(
                              text:
                                  "You can renew the policy every year till you reach 70 years of age."),
                          10.height,
                          Obx(
                            () => NoticeRow(
                                text:
                                    "So,you will be paying a total of ${controller.totalContribution.value.toStringAsFixed(0)}/- during your premium paying period of ${controller.contributionPeriod.value} years."),
                          ),
                          10.height,
                          NoticeRow(
                              text:
                                  "Your nominees will get 2 Lacs/- in case of your death during the premium paying period.")
                        ],
                      ),
                    ),
                  ),
                ),
                20.height
              ],
            ),
          ),
        ),
      ),
    );
  }
}
