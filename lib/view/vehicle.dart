import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/vehicle_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/controller/vehicle_controller.dart';
import 'package:emi_calc/view/vehicle_loan_emi_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../config/images.dart';

class Vehicle extends StatelessWidget {
  Vehicle({super.key});
  VehicleController controller = Get.put(VehicleController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Vehicle Loan"),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: 10.horizontal,
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
                      return 'Please enter valid loan amount';
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
                  text: "10",
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
                      // labelText: "Start Date",
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
                30.height,
                Row(
                  children: [
                    Text(
                      "EMI Scheme",
                      style: style(
                          color: AppColors.textcolor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    10.width,
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                              activeColor: AppColors.primarycolor,
                              splashRadius: 0,
                              value: "Standard",
                              groupValue: controller.bgroup.value,
                              onChanged: (val) {
                                controller.bgroup.value = val!;
                              }),
                        ),
                        Text(
                          "Standard",
                          style: style(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    10.width,
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                              activeColor: AppColors.primarycolor,
                              splashRadius: 0,
                              value: "Advance",
                              groupValue: controller.bgroup.value,
                              onChanged: (val) {
                                controller.bgroup.value = val!;
                              }),
                        ),
                        Text(
                          "Advance",
                          style: style(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
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
                            log("loanAmount : ${controller.loanAmount.value}");
                            log("rate : ${controller.annualRate}");

                            log("Checkbox Pre-Payments: ${controller.isSwitchChecked.value}");
                            log("Selected Date: ${controller.selectedDate.value != null ? '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}' : 'No date selected'}");

                            controller.calculateEMI();
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
                    child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
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
                                          commonLabel(label: "Total Amount :"),
                                    ),
                                    Obx(
                                      () => commonLabel(
                                        label: controller
                                            .totalLoanWithInterest.value,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 30,
                                  color: AppColors.greylight,
                                ),
                                Obx(
                                  () => dataRow(
                                    text: "Loan Amount",
                                    amount: "${controller.loanAmount.value} ₹",
                                  ),
                                ),
                                Divider(
                                  height: 30,
                                  color: AppColors.greylight,
                                ),
                                Obx(
                                  () => dataRow(
                                    text: "Annual Interest Rate",
                                    amount: "${controller.annualRate.value} %",
                                  ),
                                ),
                                Divider(
                                  height: 30,
                                  color: AppColors.greylight,
                                ),
                                Obx(
                                  () => dataRow(
                                    text: "Tenure",
                                    amount: controller.isSwitchChecked.value
                                        ? "${controller.tenure.value} years"
                                        : "${controller.tenure.value} months",
                                  ),
                                ),
                                Divider(
                                  height: 30,
                                  color: AppColors.greylight,
                                ),
                                Obx(
                                  () => dataRow(
                                    text: "Total Interest Payable",
                                    amount:
                                        "${controller.totalInterestPayable.value.toStringAsFixed(2)} ₹",
                                  ),
                                ),
                                Divider(
                                  height: 30,
                                  color: AppColors.greylight,
                                ),
                                Obx(
                                  () => dataRow(
                                    text: "Monthly EMI",
                                    amount:
                                        "${controller.emi.value.toStringAsFixed(2)} ₹",
                                  ),
                                ),
                                Divider(
                                  height: 30,
                                  color: AppColors.greylight,
                                ),
                                Obx(
                                  () => dataRow(
                                    text: "No Of Payment",
                                    amount: controller.isSwitchChecked.value
                                        ? "${int.parse(controller.tenure.value) * 12}"
                                        : "${controller.tenure.value}",
                                  ),
                                ),
                                20.height,
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.generatePdf();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primarycolor,
                                      ),
                                      child: Icon(
                                        Icons.share,
                                        color: AppColors.white,
                                      )),
                                ),
                                20.width,
                                GestureDetector(
                                  onTap: () {
                                    controller.calculateEMIBreakdown(
                                      isTenureInYears:
                                          controller.isSwitchChecked.value,
                                      tenure:
                                          double.parse(controller.tenure.value),
                                    );
                                    Get.to(() => VehicleLoanEmiDetail());
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primarycolor,
                                      ),
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: AppColors.white,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
                30.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
