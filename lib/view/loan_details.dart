import 'dart:developer';

import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/loan_details_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/view/new_calculation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controller/new_calculation_controller.dart';
import '../model/chart_model.dart';
import 'loancompare_add.dart';

class LoanDetails extends StatelessWidget {

  LoanDetails({super.key,});

// LoanEmiController controller=Get.put(LoanEmiController());
  NewCalculationController controller=Get.find();
  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /* log('Loan==>>${loan}');
      controller.loanAmount.value = loan.loanAmount.isEmpty ? '0.0' : loan.loanAmount;
      controller.annualRate.value = loan.annualRate.isEmpty ? '0.0' : loan.annualRate;
      controller.fees.value = loan.fee.isEmpty ? '0.0' : loan.fee;
      controller.tenure.value = loan.tenure.isEmpty ? '0.0' : loan.tenure;
      controller.note.value = loan.note.isEmpty ? 'N/A' : loan.note; // Assuming N/A is default for empty note
      controller.prePaidAmount.value = loan.prePayAmount.isEmpty ? '0.0' : loan.prePayAmount;
      controller.extraPayment.value = loan.extraPay.isEmpty ? '0.0' : loan.extraPay;
      controller.isSwitchChecked.value = loan.isSwitchChecked;
      controller.tenure.value = loan.tenure;
*/
      controller.calculateEMIBreakdown(isTenureInYears:  controller.isSwitchChecked.value, tenure: controller.tenure.value,);
// controller.calculateEMI();

    });


    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Padding(
        padding: 10.symmetric,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: 10.symmetric,
                width: double.maxFinite,
              decoration:commonDecoration(),
                child: Column(
                  children: [
                    Row(mainAxisSize:MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(()=> labelTextLoan(label: "${controller.loanAmount.value}" + " ₹")),
                            5.height,
                            subLabelTextLoan(text: "LOAN AMOUNT"),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(onTap: () {
                          log('c');
                          log('controller.fees.value${controller.fees.value}');
                          log('controller.fee.value${controller.fee.value}');
                          controller.loanAmountController.value.text=controller.loanAmount.value;
                          controller.annualRateController.value.text=controller.annualRate.value;
                          controller.feeController.value.text=controller.fees.value;
                          controller.tenureController.value.text=controller.tenure.value;
                          controller.noteController.value.text=controller.note.value;
                          controller.prePayAmountController.value.text=controller.prePaidAmount.value;
controller.index.value=1;

                          Get.to(()=>NewCalculation(),arguments:
                          {
                            'edit':true
                          });
                        },
                          child: Row(mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 20,
                              ),  Text("EDIT"),
                            ],
                          ),
                        ),

                      ],
                    ),
                    25.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(()=> labelTextLoan(label: "${controller.emiAmount.value}" + " ₹")),
                            5.height,
                            subLabelTextLoan(text: "EMI AMOUNT"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(()=> labelTextLoan(label: "${controller.annualRate.value}" + " %")),
                            5.height,
                            subLabelTextLoan(text: "INTEREST AMOUNT"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(()=>labelTextLoan(label:"${controller.tenure.value} ${controller.isSwitchChecked.value==false?"Month":"Year"}")),
                            5.height,
                            subLabelTextLoan(text: "TENURE"),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              20.height,
              Container(
                padding: 10.symmetric,
                width: double.maxFinite,
                  decoration:commonDecoration(),
                child: Column(
                  children: [
                    Text(
                      "Break-up of Total Payment",
                      style: style(
                        color: AppColors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    10.height,
                    // pia chart
                    Obx(() {
                      return Container(
                        height: 220,
                        width: 220,
                        child: SfCircularChart(

                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                              dataSource: [
                                ChartData(
                                  'A',
                                  double.tryParse(controller.principleAmount.value) ?? 0.0,
                                  Colors.pinkAccent,
                                ),
                                ChartData(
                                  'B',
                                  double.tryParse(controller.extraPayment.value) ?? 0.0,
                                  Colors.blueAccent,
                                ),
                                ChartData(
                                  'C',
                                  double.tryParse(controller.totalInterest.value) ?? 0.0,
                                  Colors.greenAccent,
                                ),
                                ChartData(
                                  'D',
                                  double.tryParse(controller.fee.value) ?? 0.0,
                                  Colors.yellowAccent,
                                ), ],
                              xValueMapper: (ChartData data, _) => data.category,
                              yValueMapper: (ChartData data, _) => data.value,
                              pointColorMapper: (ChartData data, _) => data.color,
                              innerRadius: '50%',
                              dataLabelSettings: const DataLabelSettings(isVisible: false,),
                            ),
                          ],
                        ),
                      );
                    }),
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        chartText(
                          text: "A",
                          color: Colors.pinkAccent,
                        ),
                        10.width,
                        chartText(
                          text: "B",
                          color: Colors.blueAccent,
                        ),
                        10.width,
                        chartText(
                          text: "C",
                          color: Colors.greenAccent,
                        ),
                        10.width,
                        chartText(
                          text: "D",
                          color: Colors.yellowAccent,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              20.height,
              Container(
                padding: 10.symmetric,
                width: double.maxFinite,
                decoration:commonDecoration(),
                child: Column(
                  children: [
                    Obx(()=> Text(
                        "Total Amount:" + "${controller.totalAmount.value}" + " ₹",
                        style: style(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "(A + B + C + D)",
                      style: style(
                          color: AppColors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500),
                    ),
                    Divider(
                      height: 30,
                      color: AppColors.greylight,
                    ),
                    Obx(()=> CountRow(text: "Principal (A)", amount: "${controller.principleAmount.value}")),
                    Divider(
                      height: 30,
                      color: AppColors.greylight,
                    ),
                    Obx(()=> CountRow(text: "Extra Payment (B)", amount: "${controller.extraPayment.value}")),
                    Divider(
                      height: 30,
                      color: AppColors.greylight,
                    ),
                    Obx(()=> CountRow(text: "Interest (C)", amount: "${controller.totalInterest.value}")),
                    Divider(
                      height: 30,
                      color: AppColors.greylight,
                    ),
                    Obx(()=> CountRow(text: "Fee & Charges (D)", amount: "${controller.fee.value}")),
                    10.height,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
