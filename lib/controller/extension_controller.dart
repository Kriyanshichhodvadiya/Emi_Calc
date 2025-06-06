

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExtensionController extends GetxController {
  Rx<TextEditingController> monthInvestController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  Rx<TextEditingController> depositController = TextEditingController().obs;

  RxString monthInvest = ''.obs;
  RxString returnRate = ''.obs;
  RxString deposit = ''.obs;

  List<String> depositType = [
    'With Deposit',
    'Without Deposit',
  ];
  List<String> yearType =
  List.generate(10, (index) => '${(index + 1) * 5} Years');

  List<String> dAmountType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];

  RxString dropdownValueDeposit = 'With Deposit'.obs;
  RxBool isValueShow = false.obs;

  RxString dropdownValueYear = '5 Years'.obs;
  RxString dropdownValueAmount = 'Monthly'.obs;
  RxDouble maturityAmount = 0.0.obs;
  RxDouble totalDepositAmount = 0.0.obs;
  RxDouble totalInterestAmount = 0.0.obs;

  void calculateMaturity() {
    isValueShow.value = true;

    double openingBalance = double.tryParse(monthInvest.value) ?? 0.0;
    double annualRate = double.tryParse(returnRate.value) ?? 0.0;
    double depositAmount = 0.0;

    // Extract years from dropdown value (e.g., "5 Years" -> 5)
    int years = int.tryParse(dropdownValueYear.value.split(' ')[0]) ?? 5;

    // Convert annual rate to decimal
    double r = annualRate / 100;

    // Default compounding frequency
    int n = 1; // Default to yearly compounding

    if (dropdownValueDeposit.value == 'With Deposit') {
      // Only consider deposit-related values if "With Deposit" is selected
      depositAmount = double.tryParse(deposit.value) ?? 0.0;

      if (dropdownValueAmount.value == 'Monthly') {
        n = 12; // Monthly compounding
      } else if (dropdownValueAmount.value == 'Quarterly') {
        n = 4; // Quarterly compounding
      } else if (dropdownValueAmount.value == 'Half-Yearly') {
        n = 2; // Half-Yearly compounding
      }
    }

    // Calculate maturity using compound interest formula for the opening balance
    double maturity = openingBalance * pow(1 + r / n, n * years);

    // Add the deposit component only if "With Deposit" is selected and deposit > 0
    if (dropdownValueDeposit.value == 'With Deposit' && depositAmount > 0) {
      double depositFactor = (pow(1 + r / n, n * years) - 1) / (r / n);
      maturity += depositAmount * depositFactor;
    }

    // Calculate total deposit and total interest
    double totalDeposit = depositAmount * years * n;
    double totalInterest = maturity - totalDeposit - openingBalance;

    // Update reactive variables
    maturityAmount.value = maturity;
    totalDepositAmount.value = totalDeposit;
    totalInterestAmount.value = totalInterest;
  }

  void clear() {
    isValueShow.value = false;
    monthInvestController.value.clear();
    returnRateController.value.clear();
    depositController.value.clear();
    dropdownValueDeposit.value = 'With Deposit';
    dropdownValueYear.value = '5 Years';
    dropdownValueAmount.value = 'Monthly';
    monthInvest.value = '';
    returnRate.value = '';
    deposit.value = '';
  }
}

/*
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExtensionController extends GetxController {
  Rx<TextEditingController> monthInvestController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  Rx<TextEditingController> depositController = TextEditingController().obs;

  RxString monthInvest = ''.obs;
  RxString returnRate = ''.obs;
  RxString deposit = ''.obs;

  List<String> depositType = [
    'With Deposit',
    'Without Deposit',
  ];
  List<String> yearType =
      List.generate(10, (index) => '${(index + 1) * 5} Years');

  List<String> dAmountType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];

  RxString dropdownValueDeposit = 'With Deposit'.obs;
  RxBool isValueShow = false.obs;

  RxString dropdownValueYear = '5 Years'.obs;
  RxString dropdownValueAmount = 'Monthly'.obs;
  RxDouble maturityAmount = 0.0.obs;
  RxDouble totalDepositAmount = 0.0.obs;
  RxDouble totalInterestAmount = 0.0.obs;

  void calculateMaturity() {
    isValueShow.value = true;

    double openingBalance = double.tryParse(monthInvest.value) ?? 0.0;
    double annualRate = double.tryParse(returnRate.value) ?? 0.0;
    double depositAmount = 0.0;

    // Extract years from dropdown value (e.g., "5 Years" -> 5)
    int years = int.tryParse(dropdownValueYear.value.split(' ')[0]) ?? 5;

    // Convert annual rate to decimal
    double r = annualRate / 100;

    // Define compounding frequency based on deposit type
    int n = 1; // Default to yearly compounding

    if (dropdownValueDeposit.value == 'With Deposit') {
      depositAmount = double.tryParse(deposit.value) ?? 0.0;

      if (dropdownValueAmount.value == 'Monthly') {
        n = 12; // Monthly compounding
      } else if (dropdownValueAmount.value == 'Quarterly') {
        n = 4; // Quarterly compounding
      } else if (dropdownValueAmount.value == 'Half-Yearly') {
        n = 2; // Half-Yearly compounding
      } else {
        n = 1; // Yearly compounding
      }
    }

    // Calculate maturity using compound interest formula
    double maturity = openingBalance * pow(1 + r / n, n * years);

    // Add the deposit component only if "With Deposit" is selected
    if (dropdownValueDeposit.value == 'With Deposit' && depositAmount > 0) {
      double depositFactor = (pow(1 + r / n, n * years) - 1) / (r / n);
      maturity += depositAmount * depositFactor;
    }
  }
    // Calculate total





void clear() {  isValueShow.value=false
;
  monthInvestController.value.clear();
  returnRateController.value.clear();
  depositController.value.clear();
  dropdownValueDeposit.value = 'With Deposit';
  dropdownValueYear.value = '5 Years';
  dropdownValueAmount.value = 'Monthly';
  monthInvest.value = '';
  returnRate.value = '';
  deposit.value = '';
}
}
*/
