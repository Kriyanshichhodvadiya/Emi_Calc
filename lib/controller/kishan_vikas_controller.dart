import 'dart:developer';
import 'dart:math'hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KishanVikasController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  RxString loanAmount = ''.obs;
  RxString annualRate = ''.obs;
RxBool isValueShow=false.obs;
  RxDouble maturityAmount = 0.0.obs;
  RxDouble totalInterest = 0.0.obs;
  RxDouble totalDeposit = 0.0.obs;



  void calculateMaturity() {
    isValueShow.value = true;

    // Parse input values
    double principal = double.tryParse(loanAmount.value) ?? 0.0; // Deposit amount
    double annualRate = double.tryParse(this.annualRate.value) ?? 0.0; // Annual rate in %
    double timeInYears = 10 + (4 / 12); // Total time: 10 years and 4 months (10.33 years)
 int compoundingFrequency = 12; // Quarterly compounding

    double rateDecimal = annualRate / 100;

    // Apply formula: A = P * (1 + r/n)^(nt)
    double maturity = principal *
        pow((1 + rateDecimal / compoundingFrequency),
            compoundingFrequency * timeInYears);

    maturity = double.parse(maturity.toStringAsFixed(2));
    maturity = (maturity * 100).roundToDouble() / 100; // Adjust final precision to nearest value

    // Calculate interest and deposit
    maturityAmount.value = maturity;
    totalInterest.value =
        double.parse((maturity - principal).toStringAsFixed(0)); // Round interest
    totalDeposit.value = principal;

    // Log the results
    log('loanAmount: $principal');
    log('rate: $annualRate%');
    log('maturityAmount: ${maturityAmount.value}');
    log('totalInterest: ${totalInterest.value}');
    log('totalDeposit: ${totalDeposit.value}');
  }
  void clear() {
    loanAmountController.value.clear();
    annualRateController.value.clear();
    loanAmount.value = '';
    annualRate.value = '';
    maturityAmount.value = 0.0;
    totalInterest.value = 0.0;
    totalDeposit.value = 0.0;
    isValueShow.value = false;
  }

}
