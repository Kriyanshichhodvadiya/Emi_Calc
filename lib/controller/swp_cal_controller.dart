import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwpCalController extends GetxController {
  // Controllers for input fields
  Rx<TextEditingController> depositController = TextEditingController().obs;
  Rx<TextEditingController> monthWithdrawController = TextEditingController().obs;
  Rx<TextEditingController> returnRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;

  // Reactive variables to store user input
  RxString deposit = ''.obs;
  RxString monthWithdraw = ''.obs;
  RxString returnRate = ''.obs;
  RxString tenure = ''.obs;

  // State management variables
  RxBool isSwitchChecked = false.obs; // false: Monthly, true: Yearly
  RxBool isValueShow = false.obs; // To toggle visibility of results

  // Results to display
  RxString finalBalance = ''.obs;
  RxString totalWithdrawals = ''.obs;
  RxString totalReturns = ''.obs;
  double balance=0.0;
  void calculateSWP() {
    isValueShow.value = true;

    // Parse inputs into usable formats
    double principal = double.tryParse(deposit.value) ?? 0.0;
    double monthlyWithdraw = double.tryParse(monthWithdraw.value) ?? 0.0;
    double annualRate = double.tryParse(returnRate.value) ?? 0.0;
    int tenureValue = int.tryParse(tenure.value) ?? 0;

    // // Validate inputs
    // if (principal <= 0 || monthlyWithdraw <= 0 || annualRate <= 0 || tenureValue <= 0) {
    //   log("Invalid input. Please check your fields.");
    //   Get.snackbar(
    //     "Invalid Input",
    //     "Please ensure all fields are filled with valid positive numbers.",
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }

    // Calculate monthly interest rate
    double monthlyRate = annualRate / 12 / 100;

    // Convert tenure to months if the switch is for years
    int tenureInMonths = isSwitchChecked.value ? tenureValue * 12 : tenureValue;
    balance = principal;
    double totalInterestEarned = 0.0;
    double totalWithdrawalAmount = 0.0;

    // Perform monthly withdrawals and interest application
    for (int i = 0; i < tenureInMonths; i++) {
      // Add monthly interest to the balance
      double interestForMonth = balance * monthlyRate;
      totalInterestEarned += interestForMonth;

      // Add interest to balance
      balance += interestForMonth;

      // Subtract the monthly withdrawal amount
      if (balance >= monthlyWithdraw) {
        balance -= monthlyWithdraw;
        totalWithdrawalAmount += monthlyWithdraw;
      } else {
        // If balance is less than the withdrawal amount, stop withdrawals
        totalWithdrawalAmount += balance;
        balance = 0;
        break;
      }

      // Update the UI
      update();
    }

    // Round results for better precision
    balance = (balance * 100).roundToDouble() / 100;
    totalInterestEarned = (totalInterestEarned * 100).roundToDouble() / 100;

    // Update results for display
    finalBalance.value = balance.toStringAsFixed(2);
    totalWithdrawals.value = totalWithdrawalAmount.toStringAsFixed(0);
    totalReturns.value = totalInterestEarned.toStringAsFixed(2);

    print("Final Balance: ₹${finalBalance.value}");
    print("Total Withdrawals: ₹${totalWithdrawals.value}");
    print("Total Returns: ₹${totalReturns.value}");


  }

}
