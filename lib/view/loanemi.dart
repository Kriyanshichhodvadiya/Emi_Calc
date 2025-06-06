import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/home_common.dart';
import 'package:emi_calc/common/loanemi_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/controller/new_calculation_controller.dart';
import 'package:emi_calc/view/calculation.dart';
import 'package:emi_calc/view/new_calculation.dart';
import 'package:emi_calc/view/recent_cal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class LoanEmi extends StatelessWidget {
  LoanEmi({super.key});
  NewCalculationController controller = Get.put(NewCalculationController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: ()async {
      Get.offAll(()=>Home());
      return false;
    },
      child: Scaffold(
        appBar: commonappbar(text: "Loan EMI",onPressed: () {
          Get.offAll(()=>Home());
        },),
        backgroundColor: AppColors.bgcolor,
        body: Padding(
          padding: 10.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                // labeltext(text: "Most Recent Calculation"),
                // MySeparator(),
                10.height,
                Obx(
                  () {
                    if (controller.loans.isEmpty) {
                      return Expanded(flex: 7,
                        child: Center(
                          child: Text(
                            "You don't have any recent Calculation",
                            style: style(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      var loan = controller.loans.last;

                      return Expanded(flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labeltext(text: "Most Recent Calculation"),
                            10.height,
                            GestureDetector(
                                onTap: () {
                                  controller.clear();
                                  try {
                                    final parts = loan.startDate
                                        .split('/'); // Split the date by '/'
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
                                    controller.selectedDate.value = DateTime
                                        .now(); // Fallback to current date
                                  }

                                  controller.loanAmount.value =
                                      loan.loanAmount;
                                  controller.annualRate.value =
                                      loan.annualRate;
                                  controller.tenure.value =
                                      loan.tenure;
                                  controller.fees.value = loan.fee;
                                  controller.note.value =
                                      loan.note;
                                  controller.prePaidAmount.value =
                                      loan.prePayAmount;
                                  controller.isSwitchChecked.value =
                                      loan.isSwitchChecked;
                                  controller.isSwitchCheckedfree.value =
                                      loan.isSwitchCheckedfree;

                                  controller.totalInterest.value =
                                      loan.interest.toString();
                                  controller.totalAmount.value =
                                      loan.totalAmount.toString();

                                  controller.dropdownValueDeposit.value =
                                      loan.depositType;
                                  controller.emiAmount.value = loan.emiAmount;
                                  controller.extraPayment.value = loan.extraPay;
                                  controller.principleAmount.value = loan.principleAmount.toStringAsFixed(0);
                                  controller.fee.value=loan.feesCharges;
                                  log('extraPay==>>${controller.extraPayment.value}');
                                  controller.calculateEMIBreakdown(isTenureInYears:  controller.isSwitchChecked.value, tenure: controller.tenure.value,);
                                controller.updateIndex.value=controller.loans.length - 1;
log('controller.updateIndex.value${controller.updateIndex.value}');
                                  Get.to(() => Calculation());
                                  log('loanamount :${controller.loanAmount.value}');
                                  log('loan:amount :${loan.loanAmount}');
                                },
                                child: Container(
                                    padding: 10.symmetric,
                                    width: double.maxFinite,
                                    decoration:commonDecoration(),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    recentCalText(
                                                        text:
                                                            "${loan.loanAmount} ₹"),
                                                    recentCalLabel(
                                                        label: "Loan Amount"),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  recentCalText(
                                                      text:
                                                          "${loan.emiAmount} ₹"),
                                                  recentCalLabel(
                                                      label: "EMI Amount"),
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
                                                          "${loan.tenure} ${loan.isSwitchChecked == false ? 'Month' : 'Year'}",
                                                    ),
                                                    recentCalLabel(
                                                        label: "Tenure"),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  recentCalText(
                                                    text:
                                                        "${loan.annualRate} ${loan.isSwitchCheckedfree == true ? '%' : '₹'}",
                                                  ),
                                                  recentCalLabel(
                                                      label: "Interest Rate"),
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
                                                    : loan.note,
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
                                                        final parts = loan.startDate
                                                            .split('/'); // Split the date by '/'
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
                                                        controller.selectedDate.value = DateTime
                                                            .now(); // Fallback to current date
                                                      }

                                                      controller.loanAmount.value =
                                                          loan.loanAmount;
                                                      controller.annualRate.value =
                                                          loan.annualRate;
                                                      controller.tenure.value =
                                                          loan.tenure;
                                                      controller.fees.value = loan.fee;
                                                      controller.note.value =
                                                          loan.note;
                                                      controller.prePaidAmount.value =
                                                          loan.prePayAmount;
                                                      controller.isSwitchChecked.value =
                                                          loan.isSwitchChecked;
                                                      controller.isSwitchCheckedfree.value =
                                                          loan.isSwitchCheckedfree;

                                                      controller.totalInterest.value =
                                                          loan.interest.toString();
                                                      controller.totalAmount.value =
                                                          loan.totalAmount.toString();

                                                      controller.dropdownValueDeposit.value =
                                                          loan.depositType;
                                                      controller.emiAmount.value = loan.emiAmount;
                                                      controller.extraPayment.value = loan.extraPay;
                                                      controller.principleAmount.value = loan.principleAmount.toString();
                                                      controller.fee.value=loan.feesCharges;
                                                      log('extraPay==>>${controller.extraPayment.value}');
                                                      controller.calculateEMIBreakdown(isTenureInYears:  controller.isSwitchChecked.value, tenure: controller.tenure.value,);
                                                      Get.to(() => Calculation());
                                                      log('loanamount :${controller.loanAmount.value}');
                                                      log('loan:amount :${loan.loanAmount}');

                                                      // Get.to(() => Calculation());
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Show Calculation",
                                                          style: style(
                                                              color:
                                                                  AppColors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
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
                                                      await controller.deleteLoan(
                                                          controller.loans.length -
                                                              1);
                                                      Get.back();
                                                    });

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
                                        ]))),
                            15.height,
                            GestureDetector(
                              onTap: () {
                                Get.to(() => RecentCal());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                width: double.maxFinite,
                                decoration:commonDecoration(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      size: 20,
                                      Icons.restore,
                                      color: AppColors.black,
                                    ),
                                    10.width,
                                    Text(
                                      "View Recent Calculation",
                                      style: style(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),

                // Spacer(),
                primarybutton(
                  text: "New Calculation",
                  onPressed: () {
                    controller.clear();
                    controller.index.value=0;
                    Get.to(() => NewCalculation(), arguments:{
                      'edit':false
                    });
                  },
                ),
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}


void deleteDialog({required void Function()?  confirmOnPressed}){
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete Loan"),
        content: Column(mainAxisSize: MainAxisSize.min,
          children: [
            Text("Are you sure you want to delete this loan?",textAlign: TextAlign.center,style: style(),),

          20.height,
          Row(mainAxisAlignment: MainAxisAlignment.end,mainAxisSize: MainAxisSize.min,children: [ primarybutton(text: 'Cancel', onPressed: (){
            Get.back();
          },width:  10.wp(context)),10.width,
            primarybutton(width:
              10.wp(context),text: 'Confirm', onPressed: confirmOnPressed,
            ),],)],
        ),

      );
    },
  );
}