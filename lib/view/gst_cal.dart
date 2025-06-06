import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/rd_cal_common.dart';
import 'package:emi_calc/config/images.dart';
import 'package:emi_calc/controller/gst_cal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../config/color.dart';

class GstCal extends StatelessWidget {
  GstCal({super.key});
  GstCalController controller = Get.put(GstCalController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "GST Calculation"),
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
                  controller: controller.amountController.value,
                  onChanged: (value) {
                    controller.amount.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Deposit Amount",
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
                  controller: controller.gstRateController.value,
                  onChanged: (value) {
                    controller.gstRate.value = value;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                              activeColor: AppColors.primarycolor,
                              splashRadius: 0,
                              value: "Add GST (+)",
                              groupValue: controller.bgroup.value,
                              onChanged: (val) {
                                controller.bgroup.value = val!;
                              }),
                        ),
                        Text(
                          "Add GST (+)",
                          style: style(
                              color: AppColors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w600),
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
                              value: "Subtract GST (-)",
                              groupValue: controller.bgroup.value,
                              onChanged: (val) {
                                controller.bgroup.value = val!;
                              }),
                        ),
                        Text(
                          "Subtract GST (-)",
                          style: style(
                              color: AppColors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w600),
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
                            controller.afterTextShow.value = true;
                            controller.calculateGST();
                            log("loanAmount : ${controller.amount.value}");
                            log("rate : ${controller.gstRate}");
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
                                text: controller.afterTextShow.value == false
                                    ? "Amount Before GST"
                                    : 'Amount After GST',
                                amount: "${controller.amountBeforeGST.value} ₹",
                              )),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => rdCalRow(
                                text: "GST Amount",
                                amount: "${controller.gstAmount.value} ₹",
                              )),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => rdCalRow(
                                text: "Total Amount",
                                amount: "${controller.totalAmount.value} ₹",
                              )),
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
