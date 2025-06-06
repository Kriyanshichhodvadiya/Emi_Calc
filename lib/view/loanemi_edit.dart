/*
import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/controller/loanemi_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/images.dart';

class LoanEmiEdit extends StatelessWidget {
  LoanEmiEdit({super.key});
  LoanemiEditController controller = Get.put(LoanemiEditController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Loan EMI"),
      body: Padding(
        padding: 10.horizontal,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                20.height,
                commonTextField(
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

                    return null;
                  },
                ),
                20.height,
                commonTextField(
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

                    return null;
                  },
                ),
                20.height,
                textFieldSwitch(
                  controller: controller.tenureController.value,
                  onChanged: (value) {
                    controller.tenure.value = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter tenure in Year/Months';
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
                20.height,
                textFieldSwitch(
                  controller: controller.feeController.value,
                  onChanged: (value) {
                    controller.fee.value = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fees & charges';
                    }
                    return null;
                  },
                  text: "Loan fees & charges",
                  label: "Fees & Charges",
                  suffixIcon: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Ensure row takes minimum space
                    children: [
                      Obx(
                        () => Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: controller.isSwitchCheckedfree.value,
                            onChanged: (value) {
                              controller.isSwitchCheckedfree.value = value;
                            },
                            activeColor: AppColors.primarycolor,
                            inactiveTrackColor: AppColors.bgcolor,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.isSwitchCheckedfree.value
                              ? 'Year'
                              : 'Month',
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
                textField(
                  controller: controller.noteController.value,
                  onChanged: (value) {
                    controller.note.value = value;
                  },
                  text: "Enter loan type,bank name,lender name etc",
                  label: "Note",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter annual interest rate';
                    }
                    return null;
                  },
                ),
                20.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pre-Payments",
                      style: style(fontWeight: FontWeight.w600, fontSize: 14),
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
                20.height,
                commonTextField(
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
                        controller.dropdownValueDeposit.value = val ?? '';
                      },
                    ),
                  ),
                ),
                20.height,
                Obx(
                  () => TextFormField(
                    cursorColor: AppColors.black,
                    readOnly: true,
                    onTap: () => controller.selectStartDate(context),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: controller.startSelectedDate.value != null
                          ? "${controller.startSelectedDate.value.day}/${controller.startSelectedDate.value.month}/${controller.startSelectedDate.value.year}"
                          : 'No date selected',
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
                        onTap: () => controller.selectStartDate(context),
                        child: Icon(Icons.calendar_month, color: Colors.grey),
                      ),
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
                            log("tenure : ${controller.fee}");
                            log("note : ${controller.note}");
                            log("Checkbox Pre-Payments: ${controller.isChecked.value}");
                            log("Selected Date: ${controller.selectedDate.value != null ? '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}' : 'No date selected'}");
                            controller.loanAmountController.value.clear();
                            controller.annualRateController.value.clear();
                            controller.tenureController.value.clear();
                            controller.feeController.value.clear();
                            controller.noteController.value.clear();
                            controller.isChecked.value = false;
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
                          controller.loanAmountController.value.clear();
                          controller.annualRateController.value.clear();
                          controller.tenureController.value.clear();
                          controller.feeController.value.clear();
                          controller.noteController.value.clear();
                          controller.isChecked.value = false;
                        },
                      ),
                    ),
                  ],
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
*/
