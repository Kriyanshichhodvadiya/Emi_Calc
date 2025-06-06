import 'dart:ui';

class ChartData {
  final String category;
  final double value;
  final Color color;

  ChartData(this.category, this.value, this.color);
}
class ComparisonChartData {
  final String month;
  final double principal;
  final double interest;
  final double totalAmount;

  ComparisonChartData({
    required this.month,
    required this.principal,
    required this.interest,
    required this.totalAmount,
  });
}
