import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/senior_citizen_common.dart';
import 'package:emi_calc/common/vehicle_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/config/images.dart';
import 'package:emi_calc/controller/kishan_vikas_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class KishanVikas extends StatelessWidget {
  KishanVikas({super.key});
  KishanVikasController controller = Get.put(KishanVikasController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(
        text: "Kishan Vikas Patra",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: 10.horizontal,
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
                  controller: controller.loanAmountController.value,
                  onChanged: (value) {
                    controller.loanAmount.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Deposit amount",
                  label: "Deposit Amount",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter deposit amount';
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
                  controller: controller.annualRateController.value,
                  onChanged: (value) {
                    controller.annualRate.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Interest Rate",
                  label: "Interest Rate(%)",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter annual interest rate';
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
                seniorCitizenRow(label: "Term", text: "10 years & 4 Months"),
                30.height,
                Row(
                  children: [
                    Expanded(
                      child: primarybutton(
                        color: AppColors.white,
                        text: "Calculate",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            log("loanAmount : ${controller.loanAmount.value}");
                            log("rate : ${controller.annualRate}");
                            controller.calculateMaturity();
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
                                child: commonLabel(label: "Maturity Amount:"),
                              ),
                              Obx(() => commonLabel(
                                  label:
                                      "${controller.maturityAmount.value.toStringAsFixed(0)} ₹")),
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => dataRow(
                                text: "Total Interest:",
                                amount:
                                    "${controller.totalInterest.value.toStringAsFixed(0)} ₹",
                              )),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => dataRow(
                                text: "Total Deposit:",
                                amount:
                                    "${controller.totalDeposit.value.toStringAsFixed(0)} ₹",
                              )),
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
