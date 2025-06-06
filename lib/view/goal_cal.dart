import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/goal_cal_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/config/images.dart';
import 'package:emi_calc/controller/goal_cal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GoalCal extends StatelessWidget {
  GoalCal({super.key});
  GoalCalController controller = Get.put(GoalCalController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Goal Calculator"),
      body: Padding(
        padding: 10.horizontal,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                20.height,
                commonTextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  img: AppImages.rs,
                  controller: controller.targetedController.value,
                  onChanged: (value) {
                    controller.targeted.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Targeted Wealth",
                  label: "Targeted Wealth",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter targeted wealth';
                    } if (value.startsWith('0') ) {
                      return 'Please enter valid amount';
                    }
                    return null;
                  },
                ),
                20.height,
                commonTextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  img: AppImages.pr,
                  controller: controller.returnRateController.value,
                  onChanged: (value) {
                    controller.returnRate.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Expected rate of return (P.A)",
                  label: "Return Rate",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expected rate of return';
                    }
                    final regExp = RegExp(r'^\d+(\.\d{1,2})?$');
                    if (!regExp.hasMatch(value)) {
                      return 'Please enter valid loan Interest rate.';
                    }

                    // Try parsing the value into a double
                    final rate = double.tryParse(value);
                    if (rate == null) {
                      return 'Please enter a valid number';
                    }

                    // Check if the rate is between 1 and 100
                    if (rate < 1 || rate > 10000) {
                      return 'Please enter valid loan Interest rate.';
                    }

                    return null;
                  },
                ),
                20.height,
                textFieldSwitch(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.tenureController.value,
                  onChanged: (value) {
                    controller.tenure.value = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter goal tenure.';
                    }
                    final rate = double.tryParse(value);
                    if (rate == null) {
                      return 'Please enter a valid number.';
                    }

                    // Check if the rate is between 1 and 100
                    if (rate < 1 || rate > 30) {
                      return 'Please enter goal tenure.';
                    }
                    return null;
                  },
                  text: "Tenure (in year)",
                  label: "Tenure",
                ),
                30.height,
                Row(
                  children: [
                    Expanded(
                      child: primarybutton(
                        color: AppColors.white,
                        text: "Calculate",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.calculateGoal();
                            log("loanAmount : ${controller.targeted.value}");
                            log("rate : ${controller.returnRate}");
                            log("rate : ${controller.tenure}");
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
                                  child: Obx(
                                () => labelColum(
                                    text: "Monthly Deposit",
                                    rs: "${controller.monthlyDeposit.value} ₹"),
                              )),
                              Expanded(
                                  child: Obx(
                                () => labelColum(
                                    text: "One Time Deposit",
                                    rs: "${controller.oneTimeDeposit.value} ₹"),
                              ))
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Padding(
                            padding: 15.horizontal,
                            child: Obx(
                              () => golDataRow(
                                  textRs:
                                      "${controller.totalMonthlyDeposit.value.toStringAsFixed(0)} ₹",
                                  label: "Total Deposit",
                                  rs: "${controller.totalOneTimeDeposit.value} ₹"),
                            ),
                          ),
                          30.height,
                          Padding(
                            padding: 15.horizontal,
                            child: Obx(
                              () => golDataRow(
                                  textRs:
                                      "${controller.totalMonthlyInterest.value} ₹",
                                  label: "Total Interest",
                                  rs: "${controller.totalOneTimeInterest.value} ₹"),
                            ),
                          ),
                          30.height,
                          Padding(
                            padding: 15.horizontal,
                            child: Obx(
                              () => golDataRow(
                                  textRs: "${controller.targeted.value} ₹",
                                  label: "Maturity Amount",
                                  rs: "${controller.targeted.value} ₹"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
