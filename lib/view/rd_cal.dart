import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/rd_cal_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/config/images.dart';
import 'package:emi_calc/controller/rd_cal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RdCal extends StatelessWidget {
  RdCal({super.key});
  RdCalController controller = Get.put(RdCalController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "RD Calculator"),
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
                  controller: controller.depositController.value,
                  onChanged: (value) {
                    controller.deposit.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter monthly investment amount",
                  label: "Monthly Amount",
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
                  text: "Enter expected interest rate",
                  label: "Expected Interest Rate",
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
                      8.width,
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
                            controller.calculateMaturity();
                            log("loanAmount : ${controller.deposit.value}");
                            log("rate : ${controller.returnRate}");
                            log("Checkbox Pre-Payments: ${controller.isSwitchChecked.value}");
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
                      padding: 20.symmetric,
                      width: double.maxFinite,
                      decoration:commonDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => rdCalRow(
                              text: "Total Investment",
                              amount: "${controller.totalInvestment.value} ₹")),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => rdCalRow(
                              text: "Total Interest",
                              amount: "${controller.totalInterest.value} ₹")),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => rdCalRow(
                              text: "Maturity Amount",
                              amount: "${controller.maturityAmount.value} ₹")),
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
