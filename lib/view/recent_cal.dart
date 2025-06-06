import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/loanemi_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/controller/new_calculation_controller.dart';
import 'package:emi_calc/view/calculation.dart';
import 'package:emi_calc/view/loanemi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentCal extends StatelessWidget {
  RecentCal({super.key});
  NewCalculationController controller = Get.put(NewCalculationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Recent Calculation"),
      body: Padding(
        padding: 0.horizontal,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => controller.loans.isEmpty
                    ? const Center(
                        child: Text("No data available"),
                      )
                    : ListView.separated(
                        padding: 15.symmetric,
                        itemCount: controller.loans.length,
                        itemBuilder: (context, i) {
                          var loan = controller.loans[i];
                          return Container(
                            padding: 10.symmetric,
                            width: double.maxFinite,
                              decoration:commonDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          recentCalText(
                                              text: "${loan.loanAmount} ₹"),
                                          recentCalLabel(label: "Loan Amount"),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        recentCalText(
                                            text: "${loan.emiAmount} ₹"),
                                        recentCalLabel(label: "EMI Amount"),
                                      ],
                                    ),
                                  ],
                                ),
                                20.height,
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          recentCalText(
                                              text:
                                                  "${loan.tenure} ${loan.isSwitchChecked == false ? 'Month' : 'Year'}"),
                                          recentCalLabel(label: "Tenure"),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        recentCalText(
                                            text:
                                                "${loan.annualRate} ${loan.isSwitchCheckedfree == false ? '%' : '₹'}"),
                                        recentCalLabel(label: "Interest Rate"),
                                      ],
                                    ),
                                  ],
                                ),
                                20.height,
                                Row(
                                  children: [
                                    Icon(
                                      size: 17,
                                      Icons.loyalty,
                                      color: AppColors.black,
                                    ),
                                    5.width,
                                    Text(
                                      loan.note.isEmpty
                                          ? "N/A"
                                          : '${loan.note}',
                                      style: style(
                                        color: AppColors.greytext,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                20.height,
                                Padding(
                                  padding: 10.horizontal,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.clear();
                                            try {
                                              final parts = loan.startDate.split(
                                                  '/'); // Split the date by '/'
                                              if (parts.length == 3) {
                                                int day = int.parse(parts[0]);
                                                int month = int.parse(parts[1]);
                                                int year = int.parse(parts[2]);
                                                controller.selectedDate.value =
                                                    DateTime(year, month, day);
                                              } else {
                                                throw FormatException(
                                                    'Invalid date format');
                                              }
                                            } catch (e) {
                                              print('Error parsing date: $e');
                                              controller.selectedDate.value =
                                                  DateTime
                                                      .now(); // Fallback to current date
                                            }

                                            controller.loanAmount
                                                .value = loan.loanAmount;
                                            controller.annualRate
                                                .value = loan.annualRate;
                                            controller.tenure.value
                                                 = loan.tenure;
                                            controller.fees.value
                                                 = loan.fee;
                                            controller.note.value
                                                 = loan.note;
                                            controller.prePaidAmount
                                                .value = loan.prePayAmount;
                                            controller.isSwitchChecked.value =
                                                loan.isSwitchChecked;
                                            controller
                                                    .isSwitchCheckedfree.value =
                                                loan.isSwitchCheckedfree;

                                            controller.totalInterest.value =
                                                loan.interest.toString();
                                            controller.totalAmount.value =
                                                loan.totalAmount.toString();
                                            controller.dropdownValueDeposit
                                                .value = loan.depositType;
                                            controller.emiAmount.value =
                                                loan.emiAmount;
                                            controller.prePaidAmount.value =
                                                loan.prePayAmount;
                                            controller.principleAmount.value = loan.principleAmount.toStringAsFixed(0);
controller.fee.value=loan.feesCharges;
log('loan.feesCharges:${loan.feesCharges}');
log('loan.fee:${loan.fee}');
                                            controller.updateIndex.value=i;
                                            log('updateIndex:recentScreen:==>>${controller.updateIndex.value}');
                                            Get.to(() => Calculation());
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "Show Calculation",
                                                style: style(
                                                    color: AppColors.blue,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              5.width,
                                              Icon(
                                                size: 20,
                                                Icons.navigate_next,
                                                color: AppColors.blue,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          deleteDialog(confirmOnPressed: () async {
                                            await controller.deleteLoan(i);
                                            Get.back();
                                          },);

                                        },
                                        child: Icon(
                                          size: 20,
                                          Icons.delete,
                                          color: AppColors.red,
                                        ),
                                      ),
                                      10.width,

                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, i) => 10.height,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
