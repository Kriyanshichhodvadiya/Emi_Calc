import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/config/images.dart';
import 'package:emi_calc/controller/new_calculation_controller.dart';
import 'package:emi_calc/view/calculation.dart';
import 'package:emi_calc/view/loanemi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NewCalculation extends StatelessWidget {
  NewCalculation({super.key});
  NewCalculationController controller = Get.put(NewCalculationController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> argument=ModalRoute.of(context)!.settings.arguments as  Map<String,dynamic>;
    bool edit=argument['edit'];
    return WillPopScope(onWillPop: () async{
      // if(edit==true){
      //   Get.off(()=>Calculation());
      // }else{
        Get.back();
      // }
      return false;
    },
      child: Scaffold(
        backgroundColor: AppColors.bgcolor,
        appBar: commonappbar(text: "Loan EMI",onPressed: () {
          // if(edit==true){
          //   Get.off(()=>Calculation());
          // }else{
            Get.back();
          // }

        },),
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: controller.loanAmountController.value,
                    onChanged: (value) {
                      controller.loanAmount.value = value;
                    },
                    keyboardType: TextInputType.number,
                    text: "Enter loan amount",
                    label: "Loan Amount",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid loan amount';
                      }

                      return null;
                    },
                  ),
                  20.height,
                  commonTextField(
                    img: AppImages.pr, inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                    controller: controller.annualRateController.value,
                    onChanged: (value) {
                      controller.annualRate.value = value;
                    },
                    keyboardType: TextInputType.number,
                    text: "Enter interest rate",
                    label: "Annual Interest Rate",
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
                  textFieldSwitch(
                    keyboardType: TextInputType.number,
                    controller: controller.tenureController.value,
                    onChanged: (value) {
                      controller.tenure.value = value;
                    },inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid Loan ';
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
                              // inactiveThumbColor: AppColors.primarycolor,
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
                      controller.fees.value = value;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      // FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {

                      if (value != null && value.isNotEmpty) {
                        // If there's an input value, proceed with validation
                        final fees = int.tryParse(value);

                        if (controller.isSwitchCheckedfree.value) {
                          // "Month" is selected (Fee is treated as an amount)
                          if (value.startsWith('0') || fees == null || fees <= 0) {
                            return 'Please enter a valid amount greater than 0.';
                          }

                        } else {   if (fees == null || fees < 1 || fees > 100) {
                          // "Year" is selected (Fee is treated as a percentage)
                          final regExp = RegExp(r'^\d+(\.\d{1,2})?$');
                          if (!regExp.hasMatch(value)) {
                            return 'Please enter valid fees rate.';
                          }
                          final rate = double.tryParse(value);
                          if (rate == null) {
                            return 'Please enter a valid number';
                          }

                          // Check if the rate is between 1 and 100
                          if (rate < 1 || rate > 100) {
                            return 'Please enter valid loan fees rate.';
                          }
                          // return 'Please enter a valid rate between 1 and 100.';
                        }

                        }
                      }

                      // No validation errors if the value is empty
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
                            controller.isSwitchCheckedfree.value ? 'Amount' : '%',
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
                  GestureDetector(
                    child: textField(
                      keyboardType: TextInputType.text,
                      controller: controller.noteController.value,
                      onChanged: (value) {
                        controller.note.value = value;
                      },
                      text: "Enter loan type,bank name,lender name etc",
                      label: "Note",
                      validator: (value) {
                        /*   if (value == null || value.isEmpty) {
                          return 'Please enter annual interest rate';
                        }
                        return null;*/
                      },
                    ),
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
                            log('controller.isChecked.value${controller.isChecked.value}');
                          },
                          activeColor: AppColors.black,
                          checkColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.isChecked.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          commonTextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            img: AppImages.rs,
                            controller: controller.prePayAmountController.value,
                            onChanged: (value) {
                              controller.prePaidAmount.value = value;
                            },
                            keyboardType: TextInputType.number,
                            text: "Enter Amount",
                            label: "Enter pre payment amount",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter pre payment amount';
                              }

                              return null;
                            },
                          ),
                          20.height,
                          Container(
                            height: 49,
                            width: double.infinity,
                            // padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color: AppColors.bgcolor,
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
                                value: controller
                                        .dropdownValueDeposit.value.isNotEmpty
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
                               Obx(
                                  () => TextFormField(
                                cursorColor: AppColors.black,
                                readOnly:
                                true, // Make the field read-only to avoid manual input
                                onTap: () => controller
                                    .startFromDate(context), // Open the date picker on tap
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  hintText: controller.startFrom.value != null
                                      ? "${controller.startFrom.value.day}/${controller.startFrom.value.month}/${controller.startFrom.value.year}"
                                      : 'Select pre payment start from',
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
                                    onTap: () =>controller
                                        .startFromDate(context),
                                    child: Icon(Icons.calendar_month, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
                              controller.calculateEMI();
                              controller.calculateEMIBreakdown(isTenureInYears:  controller.isSwitchChecked.value, tenure: controller.tenure.value,);



                              // Get.back();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
