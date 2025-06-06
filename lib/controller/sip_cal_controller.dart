import 'dart:developer';
import 'dart:math'hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SipCalController extends GetxController {
  Rx<TextEditingController> monthInvestController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  RxString monthInvest = ''.obs;
  RxString returnRate = ''.obs;
  RxString tenure = ''.obs;

  RxBool isSwitchChecked = false.obs;
  RxBool isValueShow = false.obs;
  RxString maturityAmount = ''.obs;
  RxString investedAmount = ''.obs;
  RxString estimatedReturns = ''.obs;

  void calculateSIP() {
    isValueShow.value=true;
    double principal = double.tryParse(monthInvest.value) ?? 0.0;
    double annualRate = double.tryParse(returnRate.value) ?? 0.0;
    int tenureInMonths = (isSwitchChecked.value ? (int.tryParse(tenure.value) ?? 0) * 12 : int.tryParse(tenure.value) ?? 0); // Tenure in months

    double monthlyRate = annualRate / 12 / 100;

    double maturityAmountValue = principal * ((pow(1 + monthlyRate, tenureInMonths) - 1) / monthlyRate) * (1 + monthlyRate);

    double totalInvestedAmount = principal * tenureInMonths;

    double returns = maturityAmountValue - totalInvestedAmount;

    maturityAmount.value = maturityAmountValue.toStringAsFixed(0);
    investedAmount.value = totalInvestedAmount.toStringAsFixed(0);
    estimatedReturns.value = returns.toStringAsFixed(0);

    log("Maturity Amount: ${maturityAmount.value}");
    log("Invested Amount: ${investedAmount.value}");
    log("Estimated Returns: ${estimatedReturns.value}");
  }

  void clear() {
    monthInvestController.value.clear();
    returnRateController.value.clear();
    tenureController.value.clear();
    monthInvest.value = '';
    returnRate.value = '';
    tenure.value = '';
    maturityAmount.value = '';
    investedAmount.value = '';
    estimatedReturns.value = '';
    isSwitchChecked.value = false;
    isValueShow.value = false;
  }
}
