import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../common/common_widget.dart';
import '../config/color.dart';
import '../controller/new_calculation_controller.dart';

class Chart extends StatelessWidget {
   NewCalculationController controller = Get.find();

  // Function to get the data for chart (either yearly or monthly)
  List<ChartData> getChartData() {
    List<ChartData> chartData = [];

    if (controller.selectedYear.value == null) {
      // Compute data for all years (grand totals)
      controller.getYearlyData().forEach((year, data) {
        log('Year: $year, Data: $data'); // Log yearly data for debugging
        chartData.add(ChartData(
          year,
          data['principal'] ?? 0.0,
          data['interest'] ?? 0.0,
          data['extraPayment'] ?? 0.0,
        ));
      });
    } else {
      // Compute data for the selected year (monthly breakdown)
      var monthlyData = controller.getMonthlyDataForYear(controller.selectedYear.value!);
      for (var data in monthlyData) {
        log('Month Data: $data'); // Log monthly data for debugging
        chartData.add(ChartData(
          controller.getMonthName(data['month']), // Convert month index to name
          data['principal'] ?? 0.0, // Default to 0.0 if principal is null
          data['interest'] ?? 0.0,  // Default to 0.0 if interest is null
          data['extraPayment'] ?? 0.0, // Default to 0.0 if extraPayment is null
        ));
      }
    }

    // Sort the data by the minimum value for consistency
    chartData.sort((a, b) {
      double minA = [a.principal, a.interest, a.extraPayment].reduce((a, b) => a < b ? a : b);
      double minB = [b.principal, b.interest, b.extraPayment].reduce((a, b) => a < b ? a : b);
      return minA.compareTo(minB);
    });

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration:commonDecoration(),  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(minimum: 0), // Ensuring no negative values
                      series: [
                        ColumnSeries<ChartData, String>(
                          dataSource: getChartData(),
                          xValueMapper: (ChartData data, _) => data.xAxis,
                          yValueMapper: (ChartData data, _) {
                            var extraPayment = double.tryParse(controller.extraPayment.value);
                            return extraPayment;
                          },
                          name: 'Extra Payment',
                          color: Colors.purple,
                        ),
                        ColumnSeries<ChartData, String>(
                          dataSource: getChartData(),
                          xValueMapper: (ChartData data, _) => data.xAxis,
                          yValueMapper: (ChartData data, _) => data.principal,
                          name: 'Principal',
                          color: Colors.blue,
                        ),
                        ColumnSeries<ChartData, String>(
                          dataSource: getChartData(),
                          xValueMapper: (ChartData data, _) => data.xAxis,
                          yValueMapper: (ChartData data, _) => data.interest,
                          name: 'Interest',
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        commonChartDetail(color: Colors.brown, label: 'EOY Balance'),
                        SizedBox(width: 5),
                        commonChartDetail(color: Colors.purple, label: 'Extra Payment'),
                        SizedBox(width: 5),
                        commonChartDetail(color: Colors.blue, label: 'Principal'),
                        SizedBox(width: 5),
                        commonChartDetail(color: Colors.orange, label: 'Interest'),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String xAxis;
  final double principal;
  final double interest;
  final double extraPayment;

  ChartData(this.xAxis, this.principal, this.interest, this.extraPayment);
}
