import 'dart:developer';
import 'dart:math'hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NAtionalSavingController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  RxString loanAmount = ''.obs;
  RxString annualRate = ''.obs;

  RxDouble maturityAmount = 0.0.obs;
  RxDouble totalInterest = 0.0.obs;
  RxDouble totalDeposit = 0.0.obs;
  RxBool isValueShow=false.obs;


  void calculate() {
    try {
      isValueShow.value=true;
      double principal = double.parse(loanAmount.value);
      double rate = double.parse(annualRate.value) / 100;
      int term = 5; // Fixed term of 5 years
      int n = 1; // Compounding frequency (annually)

      double maturity = principal * pow((1 + rate / n), n * term);

      maturityAmount.value = maturity;
      totalInterest.value = maturity - principal;
      totalDeposit.value = principal;

      log("maturityAmount: ${maturityAmount}");
      log("maturityAmount: ${totalInterest}");
      log("maturityAmount: ${totalDeposit}");
    } catch (e) {
      // Handle any parsing errors
      maturityAmount.value = 0.0;
      totalInterest.value = 0.0;
      totalDeposit.value = 0.0;
    }
  }

  void clear() {
    isValueShow.value=false;
    loanAmountController.value.clear();
    annualRateController.value.clear();
    loanAmount.value = '';
    annualRate.value = '';
    maturityAmount.value = 0.0;
    totalInterest.value = 0.0;
    totalDeposit.value = 0.0;
  }

}
