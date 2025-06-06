import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeniorCitizenController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  RxString loanAmount = ''.obs;
  RxString annualRate = ''.obs;
RxBool isValueShow=false.obs;
  RxDouble quarterlyInterest = 0.0.obs;
  RxDouble totalInterest = 0.0.obs;
  RxDouble totalAmount = 0.0.obs;

  void calculateInterest() {
    isValueShow.value=true;
    double loan = double.tryParse(loanAmount.value) ?? 0.0;
    double rate = double.tryParse(annualRate.value) ?? 0.0;

    // Formulas
    quarterlyInterest.value = (loan * rate) / (100 * 4);
    totalInterest.value = quarterlyInterest.value * 20; // 5 years = 20 quarters
    totalAmount.value = loan + totalInterest.value;

    log("Quarterly Interest: ${quarterlyInterest.value}");
    log("Total Interest: ${totalInterest.value}");
    log("Total Amount: ${totalAmount.value}");
  }
  void clear() {
    loanAmountController.value.clear();
    annualRateController.value.clear();
    loanAmount.value = '';
    annualRate.value = '';
    quarterlyInterest.value = 0.0;
    totalInterest.value = 0.0;
    totalAmount.value = 0.0;
    isValueShow.value = false;
  }

}
