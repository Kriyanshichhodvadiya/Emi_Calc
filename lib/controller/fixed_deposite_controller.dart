import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' hide log;
import '../config/color.dart';

class FixedDepositController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  TextEditingController textController = TextEditingController();

  RxString loanAmount = ''.obs;
  RxString annualRate = ''.obs;
  RxString tenure = ''.obs;
  List<String> depositType = [
    'Monthly Payout',
    'Quarterly Payout',
    'Half-Yearly Payout',
    'Yearly Payout',
    'Reinvestment (Cumulative)'
  ];

  RxString dropdownValueDeposit = 'Monthly Payout'.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxBool isSwitchChecked = false.obs;

  RxDouble maturityAmount = 0.0.obs;
  RxDouble totalInterest = 0.0.obs;
  var maturityDate = DateTime.now().obs;
  var durationInDays = 0.obs;
  var durationInMonths = 0.obs;
  void calculateFixedDeposit() {
    try {
      double principal = double.parse(loanAmount.value);
      double rate = double.parse(annualRate.value);
      int duration = int.parse(tenure.value);

      // Handle if tenure is in days (when switch is checked)
      if (isSwitchChecked.value) {
        // Duration is in days, calculate interest based on the actual number of days
        durationInDays.value = duration;  // Set the duration in days directly
        durationInMonths.value = duration ~/ 30;  // Approximate months for display purposes

        // Interest calculation for days
        double interest = (principal * rate * durationInDays.value) / (100 * 365);  // 365 days in a year
        totalInterest.value = interest;

        // Calculate the maturity date by adding the days directly
        DateTime maturity = selectedDate.value.add(Duration(days: duration));
        maturityDate.value = maturity;

        print("Duration: $durationInDays days");
        print("Total Interest: ₹${totalInterest.value}");
      } else {
        // If the switch is not checked, calculate based on months
        durationInDays.value = duration * 30;  // Convert months to days
        durationInMonths.value = duration;  // Set duration in months

        // Interest calculation for months (P * R * T / 100)
        double interest = (principal * rate * durationInMonths.value) / (100 * 12);  // 12 months in a year
        totalInterest.value = interest;

        // Calculate the maturity date by adding months
        DateTime maturity = DateTime(selectedDate.value.year,
            selectedDate.value.month + duration, selectedDate.value.day);
        maturityDate.value = maturity;

        print("Duration: $durationInMonths months");
        print("Total Interest: ₹${totalInterest.value}");
      }

      // Maturity amount = Principal + Interest
      maturityAmount.value = principal + totalInterest.value;

      // Debug logs
      print("Principal: $principal");
      print("Rate: $rate%");
      print("Maturity Amount: ₹${maturityAmount.value}");
      print("Maturity Date: $maturityDate");

    } catch (e) {
      print("Error in calculation: $e");
    }
  }





  void clear() {
    // Clear text fields
    loanAmountController.value.clear();
    annualRateController.value.clear();
    tenureController.value.clear();

    // Reset results
    maturityAmount.value = 0.0;
    totalInterest.value = 0.0;

    // Reset dropdown and date
    dropdownValueDeposit.value = 'Monthly Payout';
    selectedDate.value = DateTime.now();

    // Optionally reset switch
    isSwitchChecked.value = false;


  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarycolor, // Custom color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primarycolor, // Custom color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      // Update the selectedDate observable
      selectedDate.value = picked;
    }
  }
}
