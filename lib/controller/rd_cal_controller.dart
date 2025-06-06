import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RdCalController extends GetxController {
  Rx<TextEditingController> depositController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  RxString deposit = ''.obs;
  RxString returnRate = ''.obs;
  RxString tenure = ''.obs;
  RxString totalInvestment = "".obs;
  RxString totalInterest = "".obs;
  RxString maturityAmount = "".obs;
  RxBool isValueShow = false.obs;
  RxBool isSwitchChecked = false.obs;
  void calculateMaturity() {
    // Convert RxString values to double
    isValueShow.value = true;
    double monthlyDeposit = double.tryParse(deposit.value) ?? 0.0;
    double annualRate = double.tryParse(returnRate.value) ?? 0.0;
    double tenureValue = double.tryParse(tenure.value) ?? 0.0; // Avoid name conflict with the local variable

    // Check if tenure is in years or months
    if (!isSwitchChecked.value) {
      tenureValue = tenureValue / 12; // Convert months to years
    }

    // RD Calculation Parameters
    double r = annualRate / 100; // Convert percentage to decimal
    int n = 12; // Monthly compounding frequency

    // Maturity Calculation Formula
    double maturityAmount = monthlyDeposit *
        (pow((1 + r / n), (n * tenureValue)) - 1) /
        (1 - pow((1 + r / n), -1));

    // Total Investment
    double totalInvestment = monthlyDeposit * n * tenureValue;

    // Total Interest
    double totalInterest = maturityAmount - totalInvestment;

    // Update Controller Values
    this.totalInvestment.value = totalInvestment.toStringAsFixed(0);
    this.totalInterest.value = totalInterest.toStringAsFixed(0);
    this.maturityAmount.value = maturityAmount.toStringAsFixed(0);

    // Log values for debugging
    log("Deposit: $monthlyDeposit");
    log("Annual Rate: $annualRate");
    log("Tenure (in years): $tenureValue");
    log("Total Investment: $totalInvestment");
    log("Total Interest: $totalInterest");
    log("Maturity Amount: $maturityAmount");
  }


  void clear() {
    depositController.value.clear();
    returnRateController.value.clear();
    tenureController.value.clear();

    deposit.value = '';
    returnRate.value = '';
    tenure.value = '';
    totalInvestment.value = '';
    totalInterest.value = '';
    maturityAmount.value = '';
    isValueShow.value = false;

    isSwitchChecked.value = false;

    log("All fields and values have been cleared.");
  }
}
