import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../common/vehicle_common.dart';
import '../config/color.dart';
import '../config/images.dart';
import '../controller/extension_controller.dart';

class Extension extends StatelessWidget {
  Extension({super.key});
  ExtensionController controller = Get.put(ExtensionController());
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
                  text: "Enter Opening Balance",
                  label: "Opening Balance",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Opening Balance';
                    } if (value.startsWith('0') ) {
                      return 'Please enter valid Balance';
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
                  text: "Enter Annual rate",
                  label: "Annual Rate",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter annual rate';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Extension Type",
                      style: style(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black.withOpacity(0.7),
                      ),
                    ),
                    Container(
                      height: 39,
                      width: 160,
                      // padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Obx(
                        () => DropdownButton<String>(padding: const EdgeInsets.symmetric(horizontal: 12),
                          borderRadius: BorderRadius.circular(6),
                          value:
                              controller.dropdownValueDeposit.value.isNotEmpty
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            controller.dropdownValueDeposit.value = val ?? '';
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                20.height,

// Show deposit-related fields conditionally
                Obx(() {
                  if (controller.dropdownValueDeposit.value == 'With Deposit') {
                    return Column(
                      children: [
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
                              return 'Please enter Deposit Amount';
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
                              value: controller
                                      .dropdownValueAmount.value.isNotEmpty
                                  ? controller.dropdownValueAmount.value
                                  : null,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.hinttext,
                              ),
                              underline: const SizedBox(),
                              items: controller.dAmountType.map((String item) {
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
                                controller.dropdownValueAmount.value =
                                    val ?? '';
                              },
                            ),
                          ),
                        ),
                        20.height,
                      ],
                    );
                  } else {
                    return const SizedBox(
                      height: 0,
                    );
                  }
                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Years Type",
                      style: style(
                          fontWeight: FontWeight.w600,
                          color: AppColors.black.withOpacity(0.7)),
                    ),
                    Container(
                      height: 39,
                      width: 120,
                      // padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Obx(
                        () => DropdownButton<String>(
                          borderRadius: BorderRadius.circular(6),padding: const EdgeInsets.symmetric(horizontal: 12),
                          value: controller.dropdownValueYear.value.isNotEmpty
                              ? controller.dropdownValueYear.value
                              : null,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.hinttext,
                          ),
                          underline: const SizedBox(),
                          items: controller.yearType.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: style(
                                  color: AppColors.black.withOpacity(0.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            controller.dropdownValueYear.value =
                                val ?? ''; // Update value reactively
                          },
                        ),
                      ),
                    ),
                  ],
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
                            log("loanAmount : ${controller.deposit.value}");
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
                                      "${controller.maturityAmount.value.toStringAsFixed(0)} ₹")),
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
                                  "${controller.totalDepositAmount.value.toStringAsFixed(0)} ₹",
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
                                  "${controller.totalInterestAmount.value.toStringAsFixed(0)} ₹",
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
