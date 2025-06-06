import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/vehicle_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/controller/sip_cal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../config/images.dart';

class SipCal extends StatelessWidget {
  SipCal({super.key});
  SipCalController controller = Get.put(SipCalController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "SIP Calculator"),
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
                  controller: controller.monthInvestController.value,
                  onChanged: (value) {
                    controller.monthInvest.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Monthly Investment Amount",
                  label: "Monthly Investment",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter monthly investment amount';
                    }
                    if (value.startsWith('0') ) {
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
                    if (rate < 1 || rate > 100) {
                      return 'Please enter valid loan Interest rate.';
                    }

                    return null;
                  },
                ),
                20.height,
                textFieldSwitch(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: controller.tenureController.value,
                  onChanged: (value) {
                    controller.tenure.value = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter tenure in Year/Months';
                    }
                    final tenure = int.tryParse(value);
                    if (tenure == null) {
                      return 'Please enter a valid number';
                    }
                    if (controller.isSwitchChecked.value) {
                      // "Year" is selected
                      if (tenure < 1 || tenure > 30) {
                        return 'Please enter loan tenure up to 30 years.';
                      }
                    } else {
                      // "Month" is selected
                      if (tenure < 1 || tenure > 360) {
                        return 'Please enter loan tenure up to 30 years.';
                      }
                    }
                    return null;
                  },
                  text: "Tenure in Year/Months",
                  label: "Tenure",
                  suffixIcon: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Ensure row takes minimum space
                    children: [
                      Obx(
                        () => Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: controller.isSwitchChecked.value,
                            onChanged: (value) {
                              controller.isSwitchChecked.value = value;
                            },
                            activeColor: AppColors.primarycolor,
                            inactiveTrackColor: AppColors.bgcolor,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.isSwitchChecked.value ? 'Year' : 'Month',
                          style: style(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
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
                            controller.calculateSIP();
                            log("loanAmount : ${controller.monthInvest.value}");
                            log("rate : ${controller.returnRate}");

                            log("Checkbox Pre-Payments: ${controller.isSwitchChecked.value}");
                            // controller.monthInvestController.value.clear();
                            // controller.returnRateController.value.clear();
                            // controller.tenureController.value.clear();
                            // controller.isSwitchChecked.value = false;
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
                                child: commonLabel(label: "Maturity Amount :"),
                              ),
                              Obx(() => commonLabel(
                                  label:
                                      "${controller.maturityAmount.value} ₹")),
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(
                            () => dataRow(
                              text: "Invested Amount",
                              amount: "${controller.investedAmount.value} ₹",
                            ),
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(
                            () => dataRow(
                              text: "Est. Returns",
                              amount: "${controller.estimatedReturns.value} ₹",
                            ),
                          ),
                          10.height,
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
