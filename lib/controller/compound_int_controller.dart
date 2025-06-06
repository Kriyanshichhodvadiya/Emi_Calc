import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompoundIntController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  Rx<TextEditingController> regularDepositController = TextEditingController().obs;

  RxString loanAmount = ''.obs;
  RxString annualRate = ''.obs;
  RxString regularDeposit = ''.obs;
  RxString tenure = ''.obs;

  RxBool isChecked = false.obs;
  RxBool isValueShow = false.obs;
  RxBool isSwitchChecked = false.obs;
  RxDouble maturityAmountValue = 0.0.obs;
  RxDouble totalInterestValue = 0.0.obs;
  List<String> depositType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];
  List<String> regularDepositType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];
  RxString dropdownValueDeposit = 'Monthly'.obs;
  RxString regularDropdownValueDeposit = 'Monthly'.obs;

  void calculateCompoundInterest() {
    isValueShow.value=true
    ;
    try {
      double principal = double.parse(loanAmount.value);
      double rate = double.parse(annualRate.value) / 100; // Convert percentage to decimal
      int years = int.parse(tenure.value);
      double regularDepositValue = isChecked.value
          ? double.parse(regularDeposit.value)
          : 0.0; // Regular deposit if checked, else 0.0

      int n = 12; // Default to monthly compounding
      if (dropdownValueDeposit.value == 'Quarterly') {
        n = 4;
      } else if (dropdownValueDeposit.value == 'Half-Yearly') {
        n = 2;
      } else if (dropdownValueDeposit.value == 'Yearly') {
        n = 1;
      }

      // Compound Interest Formula: A = P * (1 + r/n)^(n*t)
      double maturityAmount = principal * pow(1 + rate / n, n * years);

      // If regular deposit is active, add the future value of the regular deposits
      if (regularDepositValue > 0) {
        double regularDepositFutureValue = regularDepositValue * (pow(1 + rate / n, n * years) - 1) / (rate / n);
        maturityAmount += regularDepositFutureValue;
      }

      double totalDeposit = principal + (regularDepositValue * 12 * years); // Total deposits made (principal + regular deposits)
      double totalInterest = maturityAmount - totalDeposit;

      // Update reactive variables
      maturityAmountValue.value = maturityAmount;
      totalInterestValue.value = totalInterest;

      log("Maturity Amount: ₹$maturityAmount");
      log("Total Deposit: ₹$totalDeposit");
      log("Total Interest: ₹$totalInterest");

    } catch (e) {
      log("Error in calculation: $e");
    }
  }



  void clear() {
    isValueShow.value=false
    ;
    loanAmountController.value.clear();
    annualRateController.value.clear();
    tenureController.value.clear();
    isChecked.value = false;
    loanAmount.value = '';
    annualRate.value = '';
    tenure.value = '';
    maturityAmountValue.value = 0.0;
    totalInterestValue.value = 0.0;
  }

}
