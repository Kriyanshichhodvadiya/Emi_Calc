import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/config/images.dart';
import 'package:emi_calc/controller/fixed_deposite_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'fixed_deposite_details.dart';

class FixedDeposite extends StatelessWidget {
  FixedDeposite({super.key});
  FixedDepositController controller = Get.put(FixedDepositController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Fixed Deposit"),
      body: Form(
        key: formKey,
        child: Padding(
          padding: 10.horizontal,
          child: SingleChildScrollView(
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
                  text: "Enter Investment Amount",
                  label: "Amount",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    if (value.startsWith('0') ) {
                      return 'Please enter valid amount';
                    }
                    return null;
                  },
                ),
                20.height,
                Obx(
                  () => TextFormField(
                    cursorColor: AppColors.black,
                    readOnly:
                        true, // Make the field read-only to avoid manual input
                    onTap: () => controller
                        .selectDate(context), // Open the date picker on tap
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: controller.selectedDate.value != null
                          ? "${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}"
                          : 'No date selected',
                      // labelText: "Investment Date",
                      // labelStyle: style(
                      //   color: AppColors.black.withOpacity(0.6),
                      //   fontSize: 12,
                      //   fontWeight: FontWeight.w500,
                      // ),
                      hintStyle: style(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.black.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.black),
                          borderRadius: BorderRadius.circular(5)),
                      suffixIcon: GestureDetector(
                        onTap: () => controller.selectDate(context),
                        child: Icon(Icons.calendar_month, color: Colors.grey),
                      ),
                    ),
                  ),
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
                  label: "Expected Interest Rate",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expected interest rate';
                    }

                    final regExp = RegExp(r'^\d+(\.\d{1,2})?$');
                    if (!regExp.hasMatch(value)) {
                      return 'Please enter valid expected Interest rate.';
                    }

                    // Try parsing the value into a double
                    final rate = double.tryParse(value);
                    if (rate == null) {
                      return 'Please enter a valid number';
                    }

                    // Check if the rate is between 1 and 100
                    if (rate < 1 || rate > 100) {
                      return 'Please enter valid expected Interest rate.';
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
                      return 'Please enter valid Fixed Deposit duration';
                    }
                    final tenure = int.tryParse(value);
                    if (tenure == null) {
                      return 'Please enter a valid number';
                    }
                    if (controller.isSwitchChecked.value) {
                      // "Day" is selected
                      if (tenure < 7 || tenure > 180) {
                        return 'Max. & min. term should be 7 Days and 180 Days..';
                      }
                    }
                    return null;
                  },
                  text: "Tenure in days/Months",
                  label: "Duration",
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
                          controller.isSwitchChecked.value ? 'Day' : 'Month',
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
                            log("tenure : ${controller.tenure}");
                            controller.calculateFixedDeposit();
                            Get.to(() => FixedDepositeDetails());
                            log("Selected Date: ${controller.selectedDate.value != null ? '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}' : 'No date selected'}");
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
