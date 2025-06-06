import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SukanyaController extends GetxController {
  Rx<TextEditingController> monthInvestController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;

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
  void calculateMaturity() {
    isValueShow.value = true;

    // Parse input values
    double monthlyDeposit = double.tryParse(monthInvest.value) ?? 0;
    double interestRate =
        double.tryParse(returnRate.value) ?? 12; // Default 12%
    int depositPeriod = 15; // Deposit duration in years
    int maturityPeriod = 21; // Total maturity duration in years

    // Logging input values for verification
    log("Monthly Deposit: $monthlyDeposit");
    log("Interest Rate: $interestRate");

    double rate = interestRate / 100; // Convert annual rate to decimal
    int n = 12; // Default compounding frequency (monthly)
    if (dropdownValueDeposit.value == 'Quarterly') {
      n = 4; // Quarterly compounding
    } else if (dropdownValueDeposit.value == 'Half-Yearly') {
      n = 2; // Half-yearly compounding
    } else if (dropdownValueDeposit.value == 'Yearly') {
      n = 1; // Yearly compounding
    }

    double maturityAmount = 0.0;
    double totalDepositedAmount = 0.0;

    // Loop through each year of the deposit period
    for (int year = 1; year <= depositPeriod; year++) {
      // Loop through each deposit within the year (based on compounding frequency)
      for (int i = 1; i <= n; i++) {
        double depositAmount = monthlyDeposit; // Fixed deposit amount
        totalDepositedAmount += depositAmount; // Track total deposits

        // Time left for this deposit to grow until maturity (in years)
        double t = (maturityPeriod - year + (1 - (i / n))).toDouble();

        // Compound interest calculation
        double compoundInterest = depositAmount * pow(1 + rate / n, n * t);
        maturityAmount += compoundInterest;
      }
    }

    // Logging results
    log("Total Deposited Amount: $totalDepositedAmount ₹");
    log("Total Maturity Amount: $maturityAmount ₹");
    log("Total Interest: ${maturityAmount - totalDepositedAmount} ₹");

    // Update observable values
    maturityAmountValue.value = maturityAmount;
    totalDepositValue.value = totalDepositedAmount;
    totalInterestValue.value = maturityAmount - totalDepositedAmount;
  }

/*  void calculateMaturity() {
    isValueShow.value = true;
    double monthlyDeposit = double.tryParse(monthInvest.value) ?? 0;
    double interestRate = double.tryParse(returnRate.value) ?? 12; // Default 12%
    int depositPeriod = 15; // In years
    int maturityPeriod = 21; // In years

    log("Monthly Deposit: $monthlyDeposit");
    log("Interest Rate: $interestRate");
    log("Deposit Period: $depositPeriod years");
    log("Maturity Period: $maturityPeriod years");

    double rate = interestRate / 100; // Convert to decimal
    int totalDeposits = (monthlyDeposit * 12 * depositPeriod).toInt(); // Total deposits over 15 years
    log("Total Deposits: $totalDeposits ₹");

    int n = 12; // Default for monthly compounding
    if (dropdownValueDeposit.value == 'Quarterly') {
      n = 4; // Quarterly compounding
    } else if (dropdownValueDeposit.value == 'Half-Yearly') {
      n = 2; // Half-yearly compounding
    } else if (dropdownValueDeposit.value == 'Yearly') {
      n = 1; // Yearly compounding
    }

    double maturityAmount = 0.0;
    double totalDepositedAmount = 0.0;

    // For each year of the deposit period, calculate compound interest for each deposit
    for (int year = 1; year <= depositPeriod; year++) {
      // Compound interest for each deposit made in that year
      for (int i = 1; i <= 12; i++) {
        double depositAmount = monthlyDeposit; // Deposit each month
        totalDepositedAmount += depositAmount; // Track total deposits

        // Compound interest for each deposit made this month
        double compoundInterest = depositAmount * pow(1 + rate / n, n * (maturityPeriod - year)); // Compound for the remaining period
        maturityAmount += compoundInterest;

       }
    }

    log("Total Maturity Amount: $maturityAmount ₹");

    // Set the calculated values to the observable variables
    maturityAmountValue.value = maturityAmount;
    totalDepositValue.value=totalDepositedAmount;
    totalInterestValue.value = maturityAmount - totalDepositedAmount; // Interest = maturity - total deposits
    log("Total Interest: ${maturityAmount - totalDepositedAmount} ₹");

    // Optionally, you can calculate the total deposits for clarity
    totalDepositValue.value = totalDeposits.toDouble();
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
