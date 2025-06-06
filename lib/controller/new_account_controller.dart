import 'dart:developer';
import 'dart:math' hide log; // Import math to use pow

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/common_widget.dart';
import '../config/color.dart';
import '../config/images.dart';

class NewAccountController extends GetxController {
  Rx<TextEditingController> monthInvestController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  var selectedIndex = 0.obs;
  List<String> depositType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];

  RxString dropdownValueDeposit = 'Monthly'.obs;

  RxString monthInvest = ''.obs;
  RxString returnRate = ''.obs;
  RxBool isValueShow = false.obs;
  RxDouble maturityAmountValue = 0.0.obs;
  RxDouble totalDepositValue = 0.0.obs;
  RxDouble totalInterestValue = 0.0.obs;
  void changeTab(int index) {
    selectedIndex.value = index;
  }
  void calculateMaturity() {
    // Input values
    double depositAmount = double.tryParse(monthInvest.value) ?? 0; // Regular deposit amount
    double annualRate = double.tryParse(returnRate.value) ?? 12; // Default annual interest rate
    int depositPeriod = 15; // Fixed deposit period in years
    double rate = annualRate / 100; // Convert annual rate to decimal

    // Compounding frequency
    int n = 12; // Default: Monthly
    if (dropdownValueDeposit.value == 'Quarterly') {
      n = 4; // Quarterly compounding
    } else if (dropdownValueDeposit.value == 'Half-Yearly') {
      n = 2; // Half-yearly compounding
    } else if (dropdownValueDeposit.value == 'Yearly') {
      n = 1; // Yearly compounding
    }

    // Total deposits
    double totalDeposit = depositAmount * (n * depositPeriod);

    // Future Value (Maturity Amount) using corrected formula
    double maturityAmount = depositAmount *
        ((pow(1 + rate / n, n * depositPeriod) - 1) / (rate / n)) *
        (1 + rate / n);

    // Rounding for precision
    maturityAmount = double.parse(maturityAmount.toStringAsFixed(2));
    double totalInterest = maturityAmount - totalDeposit;
    totalInterest = double.parse(totalInterest.toStringAsFixed(2));

    // Debug logs for verification
    print("Deposit Amount: $depositAmount");
    print("Annual Rate: $annualRate%");
    print("Total Deposit: ₹$totalDeposit");
    print("Maturity Amount: ₹$maturityAmount");
    print("Total Interest: ₹$totalInterest");

    // Update observable values
    maturityAmountValue.value = maturityAmount;
    totalDepositValue.value = totalDeposit;
    totalInterestValue.value = totalInterest;

    // Make results visible
    isValueShow.value = true;
  }


  /* void calculateMaturity() {
    // Input values
    double depositAmount = double.tryParse(monthInvest.value) ?? 0; // Regular deposit amount
    double annualRate = double.tryParse(returnRate.value) ?? 12; // Default annual interest rate
    int depositPeriod = 15; // Fixed deposit period in years
    double rate = annualRate / 100; // Convert annual rate to decimal

    // Compounding frequency
    int n = 12; // Default: Monthly
    if (dropdownValueDeposit.value == 'Quarterly') {
      n = 4; // Quarterly compounding
    } else if (dropdownValueDeposit.value == 'Half-Yearly') {
      n = 2; // Half-yearly compounding
    } else if (dropdownValueDeposit.value == 'Yearly') {
      n = 1; // Yearly compounding
    }

    // Total deposits
    double totalDeposit = depositAmount * (n * depositPeriod);

    // Future Value (Maturity Amount)
    double maturityAmount = depositAmount *
        ((pow(1 + rate / n, n * depositPeriod) - 1) / (rate / n)) *
        (1 + rate / n);

    // Rounding for better precision
    maturityAmount = double.parse(maturityAmount.toStringAsFixed(2));
    double totalInterest = maturityAmount - totalDeposit;
    totalInterest = double.parse(totalInterest.toStringAsFixed(2));

    // Debug logs for verification
    print("Deposit Amount: $depositAmount");
    print("Annual Rate: $annualRate%");
    print("Total Deposit: ₹$totalDeposit");
    print("Maturity Amount: ₹$maturityAmount");
    print("Total Interest: ₹$totalInterest");

    // Update observable values
    maturityAmountValue.value = maturityAmount;
    totalDepositValue.value = totalDeposit;
    totalInterestValue.value = totalInterest;

    // Make results visible
    isValueShow.value = true;
  }*/

  /*void calculateMaturity() {
    double depositAmount = double.tryParse(monthInvest.value) ?? 0; // Regular deposit amount
    double annualRate = double.tryParse(returnRate.value) ?? 12; // Default annual interest rate
    int depositPeriod = 15; // Fixed deposit period in years
    double rate = annualRate / 100; // Convert annual rate to decimal

    // Determine compounding frequency
    int n = 12; // Default for monthly compounding
    if (dropdownValueDeposit.value == 'Quarterly') {
      n = 4; // Quarterly compounding
    } else if (dropdownValueDeposit.value == 'Half-Yearly') {
      n = 2; // Half-yearly compounding
    } else if (dropdownValueDeposit.value == 'Yearly') {
      n = 1; // Yearly compounding
    }

    // Calculate total deposits based on frequency
    double totalDeposit = depositAmount * (n * depositPeriod);

    // Future Value of Regular Deposits (adjusted for compounding frequency)
    double maturityAmount = depositAmount *
        ((pow(1 + rate / n, n * depositPeriod) - 1) / (rate / n)) *
        (1 + rate / n);

    // Round results for better precision
    maturityAmount = double.parse(maturityAmount.toStringAsFixed(2));
    double totalInterest = maturityAmount - totalDeposit;
    totalInterest = double.parse(totalInterest.toStringAsFixed(2));

    // Log for debugging
    print("Deposit Amount: $depositAmount");
    print("Annual Rate: $annualRate%");
    print("Total Deposit: ₹$totalDeposit");
    print("Maturity Amount: ₹$maturityAmount");
    print("Total Interest: ₹$totalInterest");

    // Set results to observable variables
    maturityAmountValue.value = maturityAmount;
    totalDepositValue.value = totalDeposit;
    totalInterestValue.value = totalInterest;

    // Make the result visible
    isValueShow.value = true;
  }*/

  /*  void calculateMaturity() {
    double depositAmount = double.tryParse(monthInvest.value) ?? 0; // Monthly deposit amount
    double interestRate = double.tryParse(returnRate.value) ?? 12; // Default 12% interest rate
    int depositPeriod = 15; // Fixed deposit period of 15 years
    double rate = interestRate / 100; // Convert interest rate to decimal

    int n = 12; // Default for monthly compounding
    if (dropdownValueDeposit.value == 'Quarterly') {
      n = 4; // Quarterly compounding
    } else if (dropdownValueDeposit.value == 'Half-Yearly') {
      n = 2; // Half-yearly compounding
    } else if (dropdownValueDeposit.value == 'Yearly') {
      n = 1; // Yearly compounding
    }

    // Calculate the total deposit based on the deposit frequency
    double totalDeposit = depositAmount * (n * depositPeriod);

    // Applying the Future Value of Annuity formula for compounding
    double maturityAmount = depositAmount * ((pow(1 + rate / n, n * depositPeriod) - 1) / (rate / n));

    // Round the maturity amount and total interest for precision
    maturityAmount = double.parse(maturityAmount.toStringAsFixed(2));

    // Calculate the total interest
    double totalInterest = maturityAmount - totalDeposit;

    // Round the total interest for precision
    totalInterest = double.parse(totalInterest.toStringAsFixed(2));

    // Log the calculated values for debugging
    print("Deposit Amount: $depositAmount");
    print("Interest Rate: $interestRate");
    print("Total Deposit: $totalDeposit ₹");
    print("Maturity Amount: $maturityAmount ₹");
    print("Total Interest: $totalInterest ₹");

    // Set the values to observable variables
    maturityAmountValue.value = maturityAmount;
    totalDepositValue.value = totalDeposit;
    totalInterestValue.value = totalInterest;

    // Make the result section visible after calculation
    isValueShow.value = true;
  }*/


  void clear() {
    isValueShow.value = false;
    monthInvestController.value.clear();
    returnRateController.value.clear();
    dropdownValueDeposit.value = 'Monthly'; // Reset to default deposit type
    monthInvest.value = '';
    returnRate.value = '';
    maturityAmountValue.value = 0.0;
    totalDepositValue.value = 0.0;
    totalInterestValue.value = 0.0;
  }
}
