import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalCalController extends GetxController {
  Rx<TextEditingController> targetedController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;

  RxString targeted = ''.obs;
  RxString returnRate = ''.obs;
  RxString tenure = ''.obs;

  RxBool isValueShow = false.obs;
  RxString monthlyDeposit = ''.obs;
  RxString oneTimeDeposit = ''.obs;
  RxDouble totalMonthlyDeposit = 0.0.obs;
  RxString totalOneTimeDeposit = ''.obs;
  RxString totalMonthlyInterest = ''.obs;
  RxString totalOneTimeInterest = ''.obs;

  // Method to calculate Monthly Deposit and One-Time Deposit
  void calculateGoal() {
    // Parse inputs
    isValueShow.value = true;
    double targetedWealth = double.tryParse(targeted.value) ?? 0.0;
    double annualRate = double.tryParse(returnRate.value) ?? 0.0;
    int tenureInYears = int.tryParse(tenure.value) ?? 0;

    if (targetedWealth == 0 || annualRate == 0 || tenureInYears == 0) {
      // Handle invalid inputs
      monthlyDeposit.value = "Invalid Input";
      oneTimeDeposit.value = "Invalid Input";
      return;
    }

    // Convert annual rate to monthly rate
    double monthlyRate = annualRate / 12 / 100;
    int totalMonths = tenureInYears * 12;

    // Log intermediary values to debug
    log('Target Wealth: $targetedWealth');
    log('Annual Rate: $annualRate');
    log('Tenure in Months: $totalMonths');
    log('Monthly Rate: $monthlyRate');

    // Calculate Monthly Deposit using the Future Value of Annuity formula
    double monthlyDepositAmount = targetedWealth * (monthlyRate / (pow(1 + monthlyRate, totalMonths) - 1));

    // Calculate One-Time Deposit using the Present Value formula
    double oneTimeDepositAmount = targetedWealth / pow(1 + monthlyRate, totalMonths);

    // Round intermediate values to higher precision to avoid floating point issues
    monthlyDepositAmount = double.parse(monthlyDepositAmount.toStringAsFixed(4));
    oneTimeDepositAmount = double.parse(oneTimeDepositAmount.toStringAsFixed(4));

    // Log the intermediary results
    log('Calculated Monthly Deposit: $monthlyDepositAmount');
    log('Calculated One-Time Deposit: $oneTimeDepositAmount');

    // Calculate the total monthly deposit over the entire period
    double totalMonthlyDepositAmount = monthlyDepositAmount * totalMonths;

    // Calculate the total interest on monthly deposits
    double totalInterestOnMonthlyDeposit = targetedWealth - totalMonthlyDepositAmount;

    // Calculate the total interest on one-time deposit
    double futureValueOneTimeDeposit = oneTimeDepositAmount * pow(1 + monthlyRate, totalMonths);
    double totalInterestOnOneTimeDeposit = futureValueOneTimeDeposit - oneTimeDepositAmount;

    // Round the results to avoid display errors
    totalMonthlyDepositAmount = double.parse(totalMonthlyDepositAmount.toStringAsFixed(0));
    totalInterestOnMonthlyDeposit = double.parse(totalInterestOnMonthlyDeposit.toStringAsFixed(0));
    totalInterestOnOneTimeDeposit = double.parse(totalInterestOnOneTimeDeposit.toStringAsFixed(0));

    // Update the values with rounded results
    monthlyDeposit.value = monthlyDepositAmount.toStringAsFixed(0);
    oneTimeDeposit.value = oneTimeDepositAmount.toStringAsFixed(0);
    totalOneTimeDeposit.value = oneTimeDeposit.value;
    totalMonthlyDeposit.value = monthlyDepositAmount * 12 * tenureInYears;
    totalMonthlyInterest.value = totalInterestOnMonthlyDeposit.toStringAsFixed(0);
    totalOneTimeInterest.value = totalInterestOnOneTimeDeposit.toStringAsFixed(0);

    // Log final results
    log('totalOneTimeDeposit Deposit: ${totalOneTimeDeposit.value}');
    log('totalOneTimeInterest: ${totalOneTimeInterest.value}');
    log('totalMonthlyInterest Deposit: ${totalMonthlyInterest.value}');
    log('totalMonthlyDeposit Deposit: ${totalMonthlyDeposit.value}');
    log('Rounded Monthly Deposit: ${monthlyDeposit.value}');
    log('Rounded One-Time Deposit: ${oneTimeDeposit.value}');
  }

  void clear() {
    targetedController.value.clear();
    returnRateController.value.clear();
    tenureController.value.clear();
    targeted.value = '';
    returnRate.value = '';
    tenure.value = '';
    monthlyDeposit.value = '';
    oneTimeDeposit.value = '';
    totalMonthlyDeposit.value = 0.0;
    totalOneTimeDeposit.value = '';
    totalMonthlyInterest.value = '';
    totalOneTimeInterest.value = '';

    isValueShow.value = false;

  }

}
