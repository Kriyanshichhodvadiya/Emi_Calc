import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExistingAmountController extends GetxController {
  Rx<TextEditingController> monthInvestController = TextEditingController().obs;
  Rx<TextEditingController> depositController = TextEditingController().obs;

  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  Rx<TextEditingController> termYearController = TextEditingController().obs;

  List<String> depositType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];

  RxString dropdownValueDeposit = 'Monthly'.obs;

  RxString monthInvest = ''.obs;
  RxString deposit = ''.obs;

  RxString returnRate = ''.obs;
  RxString termYear = ''.obs;
  RxDouble maturityAmount = 0.0.obs;
  RxDouble totalDepositAmount = 0.0.obs;
  RxDouble totalInterestAmount = 0.0.obs;
  RxBool isValueShow = false.obs;
  var selectedIndex = 0.obs;
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void calculateMaturity() {
    isValueShow.value = true;

    // Get user inputs
    double initialBalance = double.tryParse(monthInvest.value) ?? 0.0;
    double monthlyDeposit = double.tryParse(deposit.value) ?? 0.0;
    double interestRate = double.tryParse(returnRate.value) ?? 5.0; // Default to 5%
    int years = int.tryParse(termYear.value) ?? 12; // Default to 12 years

    int n; // Number of compounding periods per year
    double effectiveDeposit = 0.0;

    // Determine compounding frequency and effective deposit
    switch (dropdownValueDeposit.value) {
      case 'Monthly':
        n = 12; // Monthly compounding
        effectiveDeposit = monthlyDeposit; // No adjustment needed
        break;

      case 'Quarterly':
        n = 4; // Quarterly compounding
        effectiveDeposit = monthlyDeposit * 3; // Adjust for 3 months
        break;

      case 'Half-Yearly':
        n = 2; // Half-yearly compounding
        effectiveDeposit = monthlyDeposit * 6; // Adjust for 6 months
        break;

      case 'Yearly':
        n = 1; // Yearly compounding
        effectiveDeposit = monthlyDeposit * 12; // Adjust for 12 months
        break;

      default:
        n = 12; // Default to monthly compounding
        effectiveDeposit = monthlyDeposit;
        break;
    }

    // Calculate total deposit
    double totalDeposit = (effectiveDeposit * years) + initialBalance;

    // Compound interest formula: A = P * (1 + r/n)^(nt)
    double r = interestRate / 100; // Convert percentage to decimal
    double maturity = initialBalance * pow(1 + r / n, n * years) +
        effectiveDeposit *
            ((pow(1 + r / n, n * years) - 1) / (r / n)) *
            (1 + r / n);

    // Calculate total interest earned
    double totalInterest = maturity - totalDeposit;

    // Round values to 2 decimal places
    maturity = double.parse(maturity.toStringAsFixed(2));
    totalDeposit = double.parse(totalDeposit.toStringAsFixed(2));
    totalInterest = double.parse(totalInterest.toStringAsFixed(2));

    // Update reactive values
    maturityAmount.value = maturity;
    totalDepositAmount.value = totalDeposit;
    totalInterestAmount.value = totalInterest;

    // Debug logs
    log("Initial Balance: ₹${initialBalance}");
    log("Monthly Deposit: ₹${monthlyDeposit}");
    log("Compounding Frequency: $n times/year");
    log("Annual Rate: $interestRate%");
    log("Term: $years years");
    log("Total Deposit: ₹${totalDeposit}");
    log("Maturity Amount: ₹${maturity}");
    log("Total Interest: ₹${totalInterest}");
  }


 /* void calculateMaturity() {
    isValueShow.value = true;

    // Get user inputs
    double depositAmount = double.tryParse(deposit.value) ?? 0.0; // Initial deposit
    double monthlyDeposit = double.tryParse(monthInvest.value) ?? 0.0; // Periodic deposit
    double interestRate = double.tryParse(returnRate.value) ?? 5.0; // Annual interest rate
    int years = int.tryParse(termYear.value) ?? 12; // Total investment term in years

    int n; // Number of compounding periods per year
    double effectiveDeposit = 0.0; // Adjusted deposit amount based on frequency

    // Adjust compounding periods and deposit frequency
    switch (dropdownValueDeposit.value) {
      case 'Monthly':
        n = 12;
        effectiveDeposit = monthlyDeposit;
        break;
      case 'Quarterly':
        n = 4;
        effectiveDeposit = monthlyDeposit * 3;
        break;
      case 'Half-Yearly':
        n = 2;
        effectiveDeposit = monthlyDeposit * 6;
        break;
      case 'Yearly':
        n = 1;
        effectiveDeposit = monthlyDeposit * 12;
        break;
      default:
        n = 12; // Default to monthly compounding
        effectiveDeposit = monthlyDeposit;
    }

    // Annual interest rate to decimal
    double r = interestRate / 100;

    // Calculate total deposit
    double totalDeposit = effectiveDeposit * (n * years / n); // Adjusted total deposit based on frequency

    // Calculate maturity amount using compound interest formula for recurring deposits
    double maturity = effectiveDeposit *
        ((pow(1 + r / n, n * years) - 1) / (r / n)) *
        (1 + r / n);

    // Calculate total interest
    double totalInterest = maturity - totalDeposit;

    // Round results to 2 decimal places for clarity
    maturity = double.parse(maturity.toStringAsFixed(2));
    totalDeposit = double.parse(totalDeposit.toStringAsFixed(2));
    totalInterest = double.parse(totalInterest.toStringAsFixed(2));

    // Update reactive values
    maturityAmount.value = maturity;
    totalDepositAmount.value = totalDeposit;
    totalInterestAmount.value = totalInterest;

    // Debug logs
    print("Initial Balance: ₹${depositAmount}");
    print("Periodic Deposit: ₹${monthlyDeposit}");
    print("Annual Rate: ${interestRate}%");
    print("Compounding Frequency: ${n} times/year");
    print("Term: ${years} years");
    print("Total Deposit: ₹${totalDeposit}");
    print("Maturity Amount: ₹${maturity}");
    print("Total Interest: ₹${totalInterest}");
  }*/


  void clear() {
    isValueShow.value = false;
    monthInvestController.value.clear();
    depositController.value.clear();
    returnRateController.value.clear();
    termYearController.value.clear();
    dropdownValueDeposit.value = 'Monthly'; // Reset dropdown to default

    // Reset all reactive variables to initial values
    monthInvest.value = '';
    deposit.value = '';
    returnRate.value = '';
    termYear.value = '';

    maturityAmount.value = 0.0;
    totalDepositAmount.value = 0.0;
    totalInterestAmount.value = 0.0;
  }
}
