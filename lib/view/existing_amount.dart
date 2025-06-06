import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../common/common_widget.dart';
import '../common/vehicle_common.dart';
import '../config/color.dart';
import '../config/images.dart';
import '../controller/existing_amount_controller.dart';

class ExistingAmount extends StatelessWidget {
  ExistingAmount({super.key});
  ExistingAmountController controller = Get.put(ExistingAmountController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
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
                  controller: controller.monthInvestController.value,
                  onChanged: (value) {
                    controller.monthInvest.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Amount Balance",
                  label: "Amount Balance",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
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
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  img: AppImages.rs,
                  controller: controller.depositController.value,
                  onChanged: (value) {
                    controller.deposit.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Deposit Amount",
                  label: "Deposit Amount",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter deposit amount';
                    } if (value.startsWith('0') ) {
                      return 'Please enter valid amount';
                    }
                    return null;
                  },
                ),
                20.height,
                Container(
                  height: 49,
                  width: double.infinity,
                  // padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.black.withOpacity(0.2),
                    ),
                  ),
                  child: Obx(
                    () => DropdownButton<String>(padding: const EdgeInsets.symmetric(horizontal: 12),
                      borderRadius: BorderRadius.circular(6),
                      // hint: Text(
                      //   "Deposit Type",
                      //   style: style(
                      //       color: AppColors.black.withOpacity(0.6),
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500),
                      // ),
                      value: controller.dropdownValueDeposit.value.isNotEmpty
                          ? controller.dropdownValueDeposit.value
                          : null,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.hinttext,
                      ),
                      underline: const SizedBox(),
                      items: controller.depositType.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: style(
                              color: AppColors.black.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? val) {
                        controller.dropdownValueDeposit.value =
                            val ?? ''; // Update value reactively
                      },
                    ),
                  ),
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
                  text: "Enter Annual rate",
                  label: "Annual Rate",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter interest rate';
                    }
                    final regExp = RegExp(r'^\d+(\.\d{1,2})?$');
                    if (!regExp.hasMatch(value)) {
                      return 'Please enter valid Annual rate.';
                    }

                    // Try parsing the value into a double
                    final rate = double.tryParse(value);
                    if (rate == null) {
                      return 'Please enter a valid number';
                    }

                    // Check if the rate is between 1 and 100
                    if (rate < 1 || rate > 100) {
                      return 'Please enter valid Annual rate.';
                    }

                    return null;
                  },
                ),
                20.height,
                textField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: controller.termYearController.value,
                  onChanged: (value) {
                    controller.termYear.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Term Completed(1 to 14)",
                  label: "Term Completed(Years)",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter completed term';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 1 || intValue > 14) {
                      return 'Please enter a value between 1 and 14 years';
                    }
                    return null;
                  },
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
                            log("loanAmount : ${controller.monthInvest.value}");
                            log("loanAmount : ${controller.returnRate.value}");
                            controller.calculateMaturity();
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
                    visible: controller.isValueShow.value == true,
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
                                      "${controller.maturityAmount.value.toStringAsFixed(2)} ₹")),
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(
                            () => dataRow(
                              text: "Total Deposit",
                              amount:
                                  "${controller.totalDepositAmount.value.toStringAsFixed(2)} ₹",
                            ),
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(
                            () => dataRow(
                              text: "Total Interest",
                              amount:
                                  "${controller.totalInterestAmount.value.toStringAsFixed(2)}",
                            ),
                          ),
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
