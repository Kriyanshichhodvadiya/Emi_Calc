import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LumpSumCalController extends GetxController {
  Rx<TextEditingController> depositController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  RxString deposit = ''.obs;
  RxString returnRate = ''.obs;
  RxString tenure = ''.obs;

  RxBool isSwitchChecked = false.obs;
  RxBool isValueShow = false.obs;

  RxString maturityAmount = ''.obs;
  RxString totalDeposit = ''.obs;
  RxString totalInterest = ''.obs;
  void calculateMaturity() {
    // Parse inputs
    isValueShow.value = true;
    double principal = double.tryParse(deposit.value) ?? 0.0;
    double annualRate = double.tryParse(returnRate.value) ?? 0.0;
    int tenureValue = int.tryParse(tenure.value) ?? 0;

    // Determine tenure in months
    int tenureInMonths = isSwitchChecked.value ? tenureValue * 12 : tenureValue;

    // Calculate monthly interest rate
    double monthlyRate = annualRate / 12 / 100;

    // Calculate interest for each month without compounding
    double interestPerMonth = principal * monthlyRate;
    double totalInterest = interestPerMonth * tenureInMonths;

    // Calculate maturity amount
    double maturityAmount = principal + totalInterest;

    // Update values
    this.maturityAmount.value = maturityAmount.toStringAsFixed(0);
    totalDeposit.value = principal.toStringAsFixed(0);
    this.totalInterest.value = totalInterest.toStringAsFixed(0);

    log('maturityAmount: $maturityAmount');
    log('tenureValue: $tenureValue');
    log('totalDeposit: $totalDeposit');
    log('totalInterest: $totalInterest');
  }
  void clear() {

    depositController.value.clear();
    returnRateController.value.clear();
    tenureController.value.clear();
    deposit.value = '';
    returnRate.value = '';
    tenure.value = '';
    maturityAmount.value = '';
    totalDeposit.value = '';
    totalInterest.value = '';
    isSwitchChecked.value = false;
    isValueShow.value = false;

  }

}
