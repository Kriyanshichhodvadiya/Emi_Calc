import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/common_widget.dart';
import '../common/home_loan_common.dart';
import '../common/vehicle_common.dart';
import '../config/color.dart';
import '../controller/vehicle_controller.dart';

class VehicleLoanEmiDetail extends StatelessWidget {
  final VehicleController controller = Get.put(VehicleController());

  // Function to convert year-month format to month name
  String getMonthName(String yearMonth) {
    Map<String, String> monthMap = {
      "01": "Jan",
      "02": "Feb",
      "03": "Mar",
      "04": "Apr",
      "05": "May",
      "06": "Jun",
      "07": "Jul",
      "08": "Aug",
      "09": "Sep",
      "10": "Oct",
      "11": "Nov",
      "12": "Dec",
    };

    String month = yearMonth.split('-')[1];
    return monthMap[month] ?? "Invalid Month";
  }

  // Function to group the data by year and calculate totals
  Map<String, Map<String, double>> getYearlyData() {
    Map<String, Map<String, double>> yearlyData = {};

    for (var item in controller.emiSchedule) {
      String year = item['year'].toString();

      if (!yearlyData.containsKey(year)) {
        yearlyData[year] = {
          'principal': 0.0,
          'interest': 0.0,
          'totalAmount': 0.0,
          'remainingBalance': 0.0,
        };
      }

      yearlyData[year]!['principal'] =
          yearlyData[year]!['principal']! + item['principal'];
      yearlyData[year]!['interest'] =
          yearlyData[year]!['interest']! + item['interest'];
      yearlyData[year]!['totalAmount'] = yearlyData[year]!['totalAmount']! +
          (item['principal'] + item['interest']);
      yearlyData[year]!['remainingBalance'] =
      item['remainingBalance']; // Take the last balance for the year
    }

    return yearlyData;
  }

  // Function to get monthly data for a selected year
  List<Map<String, dynamic>> getMonthlyDataForYear(String year) {
    return controller.emiSchedule
        .where((item) => item['year'].toString() == year)
        .toList();
  }

  // Navigate to next or previous year
  void changeYear(bool isNext) {
    final allYears = getYearlyData().keys.toList();
    if (controller.selectedYear.value != null) {
      int currentIndex = allYears.indexOf(controller.selectedYear.value!);
      if (isNext && currentIndex < allYears.length - 1) {
        controller.selectedYear.value = allYears[currentIndex + 1];
      } else if (!isNext && currentIndex > 0) {
        controller.selectedYear.value = allYears[currentIndex - 1];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Vehicle Loan"),
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
                        Obx(()=> selectYear(backOnTap: () => changeYear(false),nextOnTap:() => changeYear(true),label:   controller.selectedYear.value ?? "" )),

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
                        ...getYearlyData().entries.map((entry) {
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
                                  text: getYearlyData()
                                      .values
                                      .fold(0.0, (sum, year) =>
                                  sum + year['principal']!)
                                      .toStringAsFixed(0),  color: AppColors.white,
                                ),
                                PaymentScheduleText(
                                  text: getYearlyData()
                                      .values
                                      .fold(0.0, (sum, year) =>
                                  sum + year['interest']!)
                                      .toStringAsFixed(0),  color: AppColors.white,
                                ),
                                PaymentScheduleText(
                                  text: getYearlyData()
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
                        ...getMonthlyDataForYear(controller.selectedYear.value!)
                            .map((monthlyData) {
                          String monthName = getMonthName(monthlyData['month']);
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
                                  text: getYearlyData()[
                                  controller.selectedYear.value]![
                                  'principal']!
                                      .toStringAsFixed(0),color: AppColors.white
                                ),
                                PaymentScheduleText(
                                  text: getYearlyData()[
                                  controller.selectedYear.value]![
                                  'interest']!
                                      .toStringAsFixed(0),color: AppColors.white
                                ),
                                PaymentScheduleText(
                                  text: getYearlyData()[
                                  controller.selectedYear.value]![
                                  'totalAmount']!
                                      .toStringAsFixed(0),color: AppColors.white
                                ),
                                PaymentScheduleText(
                                  text: getYearlyData()[
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
