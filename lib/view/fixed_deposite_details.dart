import 'package:emi_calc/controller/fixed_deposite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../common/common_widget.dart';
import '../common/loan_details_common.dart';
import '../common/loanemi_common.dart';
import '../config/color.dart';
import '../model/chart_model.dart';

class FixedDepositeDetails extends StatelessWidget {
  FixedDepositeDetails({super.key});
  FixedDepositController controller = Get.find(); // Access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: 'Fixed Deposit Details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: 10.horizontal,
          child: Column(
            children: [
              20.height,
              Container(
                padding: 10.symmetric,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              recentCalText(
                                  text: " ${controller.loanAmount.value} ₹"),
                              recentCalLabel(label: "Investment Amount"),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            recentCalText(
                                text: "${controller.annualRate.value} %"),
                            recentCalLabel(label: "Investment Rate"),
                          ],
                        ),
                      ],
                    ),
                    20.height,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              recentCalText(
                                  text:
                                      "${controller.maturityAmount.toStringAsFixed(0)} ₹"),
                              recentCalLabel(label: "Maturity Amount"),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            recentCalText(
                                text:
                                    "${controller.totalInterest.toStringAsFixed(0)} ₹"),
                            recentCalLabel(label: "Total Earned Amount"),
                          ],
                        ),
                      ],
                    ),
                    10.height,
                  ],
                ),
              ),
              20.height,
              Container(
                padding: 10.symmetric,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        chartText(
                          text: "Interest",
                          color: Colors.green,
                        ),
                        15.width,
                        chartText(
                          text: "Principal",
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                    20.height,
                    Obx(() {
                      return Container(
                        height: 220,
                        width: 220,
                        child: SfCircularChart(

                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                              dataSource: [
                                ChartData(
                                  'Interest',
                                  double.tryParse(controller.totalInterest.toStringAsFixed(0)) ?? 0.0,
                                  Colors.green,
                                ),

                                ChartData(
                                  'Principal',
                                  controller.maturityAmount.value,
                                  Colors.blueAccent,
                                ), ],
                              xValueMapper: (ChartData data, _) => data.category,
                              yValueMapper: (ChartData data, _) => data.value,
                              pointColorMapper: (ChartData data, _) => data.color,
                              // dataLabelSettings: const DataLabelSettings(isVisible: true),

                              dataLabelSettings: DataLabelSettings(
                                isVisible: true, // This shows the labels
                                labelAlignment: ChartDataLabelAlignment.middle, // Optional: positions label at the center
                                labelPosition: ChartDataLabelPosition.outside, // Optional: places label outside the pie
                                textStyle: style(color: AppColors.black,fontWeight: FontWeight.w500,fontSize: 15), // Optional: styling the label text
                              ),),
                          ],
                        ),
                      );
                    }),
                    10.height,
                  ],
                ),
              ),
              20.height,
              Container(
                padding: 10.symmetric,
                width: double.maxFinite,
                decoration:commonDecoration(),
                child: Padding(
                  padding: 5.horizontal,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Maturity Date",
                            style: style(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${controller.maturityDate.value.day.toString().padLeft(2, '0')}/${controller.maturityDate.value.month.toString().padLeft(2, '0')}/${controller.maturityDate.value.year}",
                            style: style(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        height: 35,
                        color: AppColors.greylight,
                      ),
                      FixedText(
                          label: "Investment Date",
                          text:
                              "${controller.selectedDate.value.day.toString().padLeft(2, '0')}/${controller.selectedDate.value.month.toString().padLeft(2, '0')}/${controller.selectedDate.value.year}"),
                      Divider(
                        height: 35,
                        color: AppColors.greylight,
                      ),
                      FixedText(
                          label: "Duration",
                          text:
                              "${controller.tenure.value} ${controller.isSwitchChecked.value ? 'Days' : 'Months'}"),
                      Divider(
                        height: 35,
                        color: AppColors.greylight,
                      ),
                      FixedText(
                          label: "Deposit Type",
                          text: "${controller.dropdownValueDeposit.value}"),
                      10.height,
                    ],
                  ),
                ),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
