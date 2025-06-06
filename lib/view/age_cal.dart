import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/controller/age_cal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/vehicle_common.dart';

class AgeCal extends StatelessWidget {
  AgeCal({super.key});
  AgeCalController controller = Get.put(AgeCalController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Age Calculation"),
      body: SingleChildScrollView(
        child: Padding(
          padding: 10.horizontal,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                20.height,
                Obx(
                  () => TextFormField(
                    cursorColor: AppColors.black,
                    readOnly:
                        true, // Make the field read-only to avoid manual input
                    onTap: () => controller.birthSelectDate(
                        context), // Open the date picker on tap
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: controller.birthDate.value == null
                          ? 'Birth Date'
                          : '', // Show hint text if no date selected
                      labelText: "Birth Date",
                      labelStyle: style(
                        color: AppColors.black.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: style(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.black.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => controller.birthSelectDate(context),
                        child: Icon(Icons.calendar_month, color: Colors.grey),
                      ),
                    ),
                    controller: TextEditingController(
                      text: controller.birthDate.value != null
                          ? "${controller.birthDate.value!.day}/${controller.birthDate.value!.month}/${controller.birthDate.value!.year}"
                          : '', // Display the selected birth date if available
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
                        .selectDate(context), // Open the date picker on tap
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: controller.selectedDate.value == null
                          ? 'Age as on'
                          : '', // Show hint text if no date selected
                      labelText: "Age as on",
                      labelStyle: style(
                        color: AppColors.black.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: style(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.black.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => controller.selectDate(context),
                        child: Icon(Icons.calendar_month, color: Colors.grey),
                      ),
                    ),
                    controller: TextEditingController(
                      text:controller.selectedDate.value != null
                          ? "${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}"
                          : '', // Display the selected age date if available
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
                          if (controller.selectedDate.value!=null&&controller.birthDate.value!=null) {
                            controller.calculateAge();
                            log("Selected Date: ${controller.selectedDate.value != null ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}' : 'No date selected'}");
                          }else {
                            log('Please select both dates');
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
                  ()=> Visibility(visible: controller.isValueShow.value,
                    child: Container(
                      padding: 15.symmetric,
                      width: double.maxFinite,
                      decoration:commonDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  commonLabel(label: "Age:"),
                                  2.width,
                                  Obx(() => commonLabel(label: "${controller.ageYears.value}")),
                                  2.width,
                                  commonLabel(label: "Year"),
                                ],
                              ),
                              4.width,
                              Text(
                                "|",
                                style: style(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15),
                              ),
                              4.width,
                              Row(
                                children: [
                                  Obx(() => commonLabel(label: "${controller.ageMonths.value % 12}")),
                                  2.width,
                                  commonLabel(label: "Month"),
                                ],
                              ),
                              4.width,
                              Text(
                                "|",
                                style: style(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15),
                              ),
                              4.width,
                              Row(
                                children: [
                                  Obx(() => commonLabel(label: "${controller.ageDays.value % 7}")),
                                  2.width,
                                  commonLabel(label: "Days"),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => dataRow(
                            fontSize: 12,
                            text: "Age in Month",
                            amount: "${controller.ageMonths.value}",
                          )),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => dataRow(
                            fontSize: 12,
                            text: "Age in Weeks",
                            amount: "${controller.ageWeeks.value}",
                          )),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => dataRow(
                            fontSize: 12,
                            text: "Age in Days",
                            amount: "${controller.ageDays.value}",
                          )),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => dataRow(
                            fontSize: 12,
                            text: "Age in Hours",
                            amount: "${controller.ageHours.value}",
                          )),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => dataRow(
                            fontSize: 12,
                            text: "Age in Minutes",
                            amount: "${controller.ageMinutes.value}",
                          )),
                          Divider(
                            height: 30,
                            color: AppColors.greylight,
                          ),
                          Obx(() => dataRow(
                            fontSize: 12,
                            text: "Age in Seconds",
                            amount: "${controller.ageSeconds.value}",
                          )),
                        ],
                      ),
                    ),
                  ),
                ),

                20.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
