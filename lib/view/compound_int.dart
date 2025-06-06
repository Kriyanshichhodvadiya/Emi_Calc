import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/images.dart';
import 'package:emi_calc/controller/compound_int_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../common/vehicle_common.dart';
import '../config/color.dart';

class CompoundInt extends StatelessWidget {
  CompoundInt({super.key});
  CompoundIntController controller = Get.put(CompoundIntController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Compound Interest"),
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
                  text: "Enter loan amount",
                  label: "Loan Amount",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loan amount';
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
                  text: "Enter interest rate",
                  label: "Annual Interest Rate",
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
                      return 'Please enter a valid tenure';
                    }
                    if (controller.isSwitchChecked.value) {
                      // "Year" is selected
                      if (tenure < 1 || tenure > 36) {
                        return 'Please enter a valid tenure.';
                      }
                    } else {
                      // "Month" is selected
                      if (tenure < 1 || tenure > 360) {
                        return 'Please enter a valid tenure.';
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
                      hint: Text(
                        "Deposit Type",
                        style: style(
                            color: AppColors.black.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Regular Deposit",
                      style: style(fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                    Obx(
                      () => Checkbox(
                        value: controller.isChecked.value,
                        onChanged: (value) {
                          controller.isChecked.value = value!;
                        },
                        activeColor: AppColors.black,
                        checkColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isChecked.value == true,
                    child: Column(
                      children: [
                        commonTextField(
                          img: AppImages.pr,
                          controller: controller.regularDepositController.value,
                          onChanged: (value) {
                            controller.regularDeposit.value = value;
                          },
                          keyboardType: TextInputType.number,
                          text: "Enter interest Value",
                          label: "Annual Interest Rate",
                          validator: controller.isChecked.value == true
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter annual interest rate';
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
                                }
                              : null,
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
                              hint: Text(
                                "Deposit Type",
                                style: style(
                                    color: AppColors.black.withOpacity(0.6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              value: controller.regularDropdownValueDeposit
                                      .value.isNotEmpty
                                  ? controller.regularDropdownValueDeposit.value
                                  : null,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.hinttext,
                              ),
                              underline: const SizedBox(),
                              items: controller.regularDepositType
                                  .map((String item) {
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
                                controller.regularDropdownValueDeposit.value =
                                    val ?? ''; // Update value reactively
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                20.height,
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
                            log("tenure : ${controller.tenure}");
                            controller.calculateCompoundInterest();
                            log("Checkbox Pre-Payments: ${controller.isChecked.value}");
                          }
                        },
                      ),
                    ),
                    20.width,
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
                                child: commonLabel(label: "Maturity Amount :"),
                              ),
                              Obx(() => commonLabel(
                                  label:
                                      "₹${controller.maturityAmountValue.value.toStringAsFixed(2)}")),
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(
                            () => dataRow(
                              text: "Total Deposit",
                              amount: controller.isChecked.value == false
                                  ? "₹ ${controller.loanAmount.value}"
                                  : "₹ ${controller.maturityAmountValue.value - controller.totalInterestValue.value}",
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
                                  "₹${controller.totalInterestValue.value.toStringAsFixed(2)}",
                            ),
                          ),
                          10.height,
                        ],
                      ),
                    ),
                  ),
                ),
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
