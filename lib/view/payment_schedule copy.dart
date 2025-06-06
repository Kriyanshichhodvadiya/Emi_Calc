import 'package:dotted_border/dotted_border.dart';
import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/home_loan_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/controller/new_calculation_controller.dart';
import 'package:flutter/material.dart';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/common_widget.dart';
import '../common/home_loan_common.dart';
import '../common/vehicle_common.dart';
import '../config/color.dart';
import '../controller/vehicle_controller.dart';

class PaymentSchedule extends StatelessWidget {
  NewCalculationController controller=Get.find();



  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedYear.value =null;
    });

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      /*appBar: commonappbar(text: "Payment Schedule"),*/
      body: Form(
        key: GlobalKey<FormState>(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Visibility Widget to show the selected year
                Obx(
                      () => Visibility(
                    visible: controller.selectedYear.value != null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(()=> selectYear(backOnTap: () => controller.changeYear(false),nextOnTap:() => controller.changeYear(true),label:   controller.selectedYear.value ?? "" )),

                        10.width,
                        viewAllBtn(onTap:(){

                          controller.selectedYear.value = null;
                        }),
                      ],
                    ),
                  ),
                ),
                10.height,
                Obx(
                      () => controller.emiSchedule.isEmpty
                      ? SizedBox.shrink()
                      : Column(
                    children: [
                      Table(
                        border: TableBorder.all(
                          color: AppColors.grey,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        columnWidths: {
                          0: FixedColumnWidth(70),
                          1: FixedColumnWidth(70),
                          2: FixedColumnWidth(70),
                          3: FixedColumnWidth(70),
                          4: FixedColumnWidth(60),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: AppColors.box),
                            children: [
                              HeaderText(label: "Principal Amount \n(A)"),
                              HeaderText(label: "Interest Amount \n(B)"),
                              HeaderText(label: "Total \nAmount\n(A+B)"),
                              HeaderText(label: "Remaining Balance\n(₹)"),
                              HeaderText(label: "\nYear"),
                            ],
                          ),
                        ],
                      ),
                      if (controller.selectedYear.value == null)
                      // Show all yearly totals if no year is selected
                        ...controller.getYearlyData().entries.map((entry) {
                          String year = entry.key;
                          var totals = entry.value;

                          return GestureDetector(
                            onTap: () {
                              controller.selectedYear.value = year;
                            },
                            child:  Table(
                              border: TableBorder.symmetric(inside:BorderSide(color: AppColors.grey,width: 1),outside: BorderSide(color: AppColors.grey,width: 0.5),

                              ),
                              columnWidths: {
                                0: FixedColumnWidth(70),
                                1: FixedColumnWidth(70),
                                2: FixedColumnWidth(70),
                                3: FixedColumnWidth(70),
                                4: FixedColumnWidth(60),
                              },
                              children: [
                                TableRow(  decoration: BoxDecoration(
                                  color: AppColors.white,
                                ),
                                  children: [
                                    PaymentScheduleText(
                                      text: totals['principal']!
                                          .toStringAsFixed(0),
                                    ),
                                    PaymentScheduleText(
                                      text: totals['interest']!
                                          .toStringAsFixed(0),
                                    ),
                                    PaymentScheduleText(
                                      text: totals['totalAmount']!
                                          .toStringAsFixed(0),
                                    ),
                                    PaymentScheduleText(
                                      text: totals['remainingBalance']!
                                          .toStringAsFixed(0),
                                    ),
                                    PaymentScheduleText(
                                      text: year,
                                      color: AppColors.primarycolor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      if (controller.selectedYear.value == null)
                      // Compute and show grand totals
                        Table(
                          border: TableBorder.all(
                            color: AppColors.grey,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          columnWidths: {
                            0: FixedColumnWidth(70),
                            1: FixedColumnWidth(70),
                            2: FixedColumnWidth(70),
                            3: FixedColumnWidth(70),
                            4: FixedColumnWidth(60),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: AppColors.box,

                              ),
                              children: [
                                PaymentScheduleText(
                                  text: controller.getYearlyData()
                                      .values
                                      .fold(0.0, (sum, year) =>
                                  sum + year['principal']!)
                                      .toStringAsFixed(0),  color: AppColors.white,
                                ),
                                PaymentScheduleText(
                                  text: controller.getYearlyData()
                                      .values
                                      .fold(0.0, (sum, year) =>
                                  sum + year['interest']!)
                                      .toStringAsFixed(0),  color: AppColors.white,
                                ),
                                PaymentScheduleText(
                                  text: controller.getYearlyData()
                                      .values
                                      .fold(0.0, (sum, year) =>
                                  sum + year['totalAmount']!)
                                      .toStringAsFixed(0),  color: AppColors.white,
                                ),
                                PaymentScheduleText(
                                  text: '0',  color: AppColors.white,
                                ),
                                PaymentScheduleText(
                                  text: '-',
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (controller.selectedYear.value != null)
                        ...controller.getMonthlyDataForYear(controller.selectedYear.value!)
                            .map((monthlyData) {
                          String monthName = controller.getMonthName(monthlyData['month']);
                          return   Table(
                            border: TableBorder.symmetric(inside:BorderSide(color: AppColors.grey,width: 1),outside: BorderSide(color: AppColors.grey,width: 0.5),
                              // color: AppColors.grey,
                              // width:0.5,
                              // style: BorderStyle.solid,
                            ),
                            columnWidths: {
                              0: FixedColumnWidth(70),
                              1: FixedColumnWidth(70),
                              2: FixedColumnWidth(70),
                              3: FixedColumnWidth(70),
                              4: FixedColumnWidth(60),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                ),
                                children: [
                                  PaymentScheduleText(
                                    text: monthlyData['principal']
                                        .toStringAsFixed(0),
                                  ),
                                  PaymentScheduleText(
                                    text: monthlyData['interest']
                                        .toStringAsFixed(0),
                                  ),
                                  PaymentScheduleText(
                                    text: (monthlyData['principal'] +
                                        monthlyData['interest'])
                                        .toStringAsFixed(0),
                                  ),
                                  PaymentScheduleText(
                                    text: monthlyData['remainingBalance']
                                        .toStringAsFixed(0),
                                  ),
                                  PaymentScheduleText(
                                    text: monthName,  // Display the month name
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      if (controller.selectedYear.value != null)
                      // Show total at the bottom of the selected year's data
                        Table(
                          border: TableBorder.all(
                            color: AppColors.grey,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          columnWidths: {
                            0: FixedColumnWidth(70),
                            1: FixedColumnWidth(70),
                            2: FixedColumnWidth(70),
                            3: FixedColumnWidth(70),
                            4: FixedColumnWidth(60),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                  color: AppColors.box),
                              children: [
                                PaymentScheduleText(
                                    text: controller.getYearlyData()[
                                    controller.selectedYear.value]![
                                    'principal']!
                                        .toStringAsFixed(0),color: AppColors.white
                                ),
                                PaymentScheduleText(
                                    text: controller.getYearlyData()[
                                    controller.selectedYear.value]![
                                    'interest']!
                                        .toStringAsFixed(0),color: AppColors.white
                                ),
                                PaymentScheduleText(
                                    text: controller.getYearlyData()[
                                    controller.selectedYear.value]![
                                    'totalAmount']!
                                        .toStringAsFixed(0),color: AppColors.white
                                ),
                                PaymentScheduleText(
                                    text: controller.getYearlyData()[
                                    controller.selectedYear.value]![
                                    'remainingBalance']!
                                        .toStringAsFixed(0),color: AppColors.white
                                ),
                                PaymentScheduleText(
                                  text: '-', // Placeholder for empty cell
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
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

