/*
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/color.dart';

class LoanEmiController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> prePayAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  Rx<TextEditingController> feeController = TextEditingController().obs;
  Rx<TextEditingController> noteController = TextEditingController().obs;

  RxString loanAmount = '10000'.obs;
  RxString prePaidAmount = '100'.obs;
  RxString annualRate = '12'.obs;
  RxString tenure = '2'.obs;
  RxString fee = '25'.obs;
  RxString note = 'Loan Emi'.obs;

  RxString dropdownValueDeposit = 'Monthly'.obs;
  RxBool isChecked = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> startFrom = DateTime.now().obs;

  RxBool isSwitchChecked = false.obs;
  RxBool isSwitchCheckedfree = false.obs;

  List<String> depositType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];

  // EMI Calculation
  RxString emiAmount = '10000'.obs;
  RxString totalInterest = '250'.obs;
  RxString totalAmount = '200'.obs;
  RxString fees = '58'.obs;
  RxString extraPayment = '100'.obs;

  // Method to calculate the EMI
  void calculateEMI() {
    // Parse user inputs
    double loanAmountVal = double.tryParse(loanAmountController.value.text) ?? 0.0;
    double annualRateVal = double.tryParse(annualRateController.value.text) ?? 0.0;
    int tenureVal = int.tryParse(tenureController.value.text) ?? 0;
    double feeVal = double.tryParse(feeController.value.text) ?? 0.0;
    double prePayAmountVal = double.tryParse(prePayAmountController.value.text) ?? 0.0;

    // Calculate EMI (formula: P * r * (1 + r) ^ n / ((1 + r) ^ n - 1))
    double r = annualRateVal / 100 / 12; // Monthly interest rate
    int n = tenureVal * (isSwitchChecked.value ? 12 : 1); // Total number of months or years

    if (loanAmountVal <= 0 || annualRateVal <= 0 || tenureVal <= 0) {
      emiAmount.value = "Invalid input";
      return;
    }

    double emi = (loanAmountVal * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);

    // Calculate interest and total amount
    double totalInterestVal = emi * n - loanAmountVal;
    double totalAmountVal = loanAmountVal + totalInterestVal;

    // Calculate fee (either percentage or fixed amount based on the switch)
    double feeAmount = isSwitchCheckedfree.value ? (loanAmountVal * feeVal / 100) : feeVal;

    // Calculate extra payment (if prepayment is enabled)
    double extraPaymentVal = isChecked.value ? prePayAmountVal : 0.0;

    // Update the values for the UI
    emiAmount.value = emi.toStringAsFixed(2);
    totalInterest.value = totalInterestVal.toStringAsFixed(2);
    totalAmount.value = totalAmountVal.toStringAsFixed(2);
    fees.value = feeAmount.toStringAsFixed(2);
    extraPayment.value = extraPaymentVal.toStringAsFixed(2);
log("emiAmount${emiAmount}");
log("totalInterest${totalInterest}");
log("totalAmount${totalAmount}");
log("fees${fees}");
log("extraPayment${extraPayment}");
  }

  // Method to reset all values
  void clear() {
    loanAmountController.value.clear();
    prePayAmountController.value.clear();
    annualRateController.value.clear();
    tenureController.value.clear();
    feeController.value.clear();
    noteController.value.clear();
    emiAmount.value = '';
    totalInterest.value = '';
    totalAmount.value = '';
    fees.value = '';
    extraPayment.value = '';
    isChecked.value = false;
    isSwitchChecked.value = false;
    isSwitchCheckedfree.value = false;
    dropdownValueDeposit.value = 'Monthly'; // Reset to default
  }

  // Date selection for loan start date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarycolor, // Custom color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primarycolor, // Custom color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      // Update the selectedDate observable
      selectedDate.value = picked;
    }
  }
}
*/
