import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/common_widget.dart';
import '../model/loan_model.dart';

class LoanCompareAddController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> prePayAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  Rx<TextEditingController> feeController = TextEditingController().obs;
  Rx<TextEditingController> noteController = TextEditingController().obs;
RxBool updateBtn=false.obs;
int index=0;
  RxString loanAmount = ''.obs;
  RxString prePaidAmount = ''.obs;
  RxString annualRate = ''.obs;
  RxString tenure = ''.obs;
  RxString fee = ''.obs;
  RxString note = ''.obs;
  Rx<DateTime> selectedDate = DateTime
      .now()
      .obs;
  Rx<DateTime> startFrom = DateTime
      .now()
      .obs;

  RxBool isChecked = false.obs;
  RxBool isSwitchChecked = false.obs;
  RxBool isSwitchCheckedfree = false.obs;
  RxString dropdownValueDeposit = 'Monthly'.obs;

  List<String> depositType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];


  @override
  void onInit() {
    super.onInit();
    loadLoansFromStorage();
  }
  Future<void> addLoanFromCompareByIndex(int index) async {
    if (index >= 0 && index < loans.length) {
      Loan selectedLoan = loans[index];
      await addLoanFromCompare(selectedLoan); // Use the existing method to save
      log('Loan at index $index added to comparison');
    } else {
      log('Invalid index: $index');
    }
  }

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

  Future<void> startDate(BuildContext context) async {
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

    if (picked != null && picked != startFrom.value) {
      // Update the selectedDate observable
      startFrom.value = picked;
    }
  }

  RxList<Loan> loans = <Loan>[].obs;
  RxString emiAmount = '10000'.obs;
  RxString totalInterest = ''.obs;
  RxString totalAmount = '200'.obs;
  RxString fees = ''.obs;
  RxString extraPayment = '0.0'.obs;
  RxString totalPrincipal = '0.0'.obs;
  RxString principleAmount = '0'.obs;
  Future<void> calculateEMI() async {
    double loanAmountVal =
        double.tryParse(loanAmountController.value.text) ?? 0.0;
    double annualRateVal =
        double.tryParse(annualRateController.value.text) ?? 0.0;
    int tenureVal = int.tryParse(tenureController.value.text) ?? 0;
    double feeVal = double.tryParse(feeController.value.text) ?? 0.0;
    double prePayAmountVal =
        double.tryParse(prePayAmountController.value.text) ?? 0.0;

    // Convert annual interest rate to monthly rate
    double r = annualRateVal / 100 / 12;

    // Calculate tenure in months (if tenure is in years, multiply by 12)
    int n = tenureVal * (isSwitchChecked.value ? 12 : 1);

    // EMI Calculation using the provided formula
    double emi = (loanAmountVal * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);

    // Total Amount and Total Interest Calculation
    double totalAmountVal = emi * n;  // Total amount to be paid (EMI * tenure in months)
    double totalInterestVal = totalAmountVal - loanAmountVal;  // Total interest is the total amount minus the principal

    // Apply the prepayment to the total interest (it reduces the principal)
    double adjustedLoanAmount = loanAmountVal - prePayAmountVal; // Adjusted loan after prepayment
    double adjustedTotalInterestVal = adjustedLoanAmount * r * pow(1 + r, n) / (pow(1 + r, n) - 1) * n - adjustedLoanAmount;

    // Correct Fee Calculation: Apply fee based on whether it's a percentage or fixed amount
    double feeAmount = 0.0;
    if (isSwitchCheckedfree.value) {
      // Fee is a fixed amount
      feeAmount = feeVal;
    } else {
      // Fee is a percentage of the loan amount
      feeAmount = (loanAmountVal * feeVal) / 100;
    }

    // Prepayment Calculation (extra payments)
    double extraPaymentVal = isChecked.value ? prePayAmountVal : 0.0;

    if (isSwitchChecked.value) { // When tenure is in months
      int month = 12 * tenureVal;

      switch (dropdownValueDeposit.value) {
        case 'Monthly':
          extraPaymentVal = prePayAmountVal * month - prePayAmountVal;
          break;
        case 'Quarterly':
          extraPaymentVal = prePayAmountVal * month / 3;
          break;
        case 'Half-Yearly':
          extraPaymentVal = prePayAmountVal * month / 2;
          break;
        case 'Yearly':
          extraPaymentVal = prePayAmountVal * month;
          break;
        default:
          extraPaymentVal = prePayAmountVal;
      }
    } else { // When tenure is in years
      switch (dropdownValueDeposit.value) {
        case 'Monthly':
          var month = 12 * tenureVal;
          extraPaymentVal = prePayAmountVal * month - prePayAmountVal;
          break;
        case 'Quarterly':
          var month = 12 * tenureVal;
          extraPaymentVal = prePayAmountVal * month / 3;
          break;
        case 'Half-Yearly':
          var month = 12 * tenureVal;
          extraPaymentVal = prePayAmountVal * month / 2;
          break;
        case 'Yearly':
          var month = 12 * tenureVal;
          extraPaymentVal = prePayAmountVal * month;
          break;
        default:
          extraPaymentVal = prePayAmountVal;
      }
    }

    log('extraPaymentVal:==>>${extraPaymentVal}');

    // Calculate the principle after applying prepayments
    double principleAmountVal = loanAmountVal - extraPaymentVal;
    double adjustedPrinciple = principleAmountVal - prePayAmountVal;

    // Updating the UI values
    emiAmount.value = emi.toStringAsFixed(0);
    totalInterest.value = adjustedTotalInterestVal.toStringAsFixed(0); // Correct interest after prepayment
    // totalAmount.value = (emi * n).toStringAsFixed(0); // Total amount to be paid

    fee.value = feeAmount.toStringAsFixed(0);
    extraPayment.value = extraPaymentVal.toStringAsFixed(0);
    principleAmount.value = principleAmountVal.toStringAsFixed(0);
    double totalAmountCalculated = feeAmount + extraPaymentVal + principleAmountVal + totalInterestVal;

// Update totalAmount value
    totalAmount.value = totalAmountCalculated.toStringAsFixed(0);
    log("principleAmount${principleAmount}");
    log("emiAmount${emiAmount}");
    log("totalInterest${totalInterest}");
    log("totalAmount${totalAmount}");
    log("fees${fees}");
    log("extraPayment${extraPayment}");

    if (double.parse(principleAmount.value) < 0) {
      primaryToast(
        msg: "Please enter a prepaid amount that is less than the loan amount. ",

      );
    } else {
      log('isSwitchChecked==>>tenure ${isSwitchChecked.value}');
      log('isSwitchCheckedfree==>>fees ${isSwitchCheckedfree.value}');
      Loan loan = Loan(
        loanAmount: loanAmountController.value.text,
        annualRate: annualRateController.value.text,
        tenure: tenureController.value.text,
        fee: feeController.value.text,
        note: noteController.value.text,
        isPrePaymentChecked: isChecked.value,
        isSwitchChecked: isSwitchChecked.value,
        isSwitchCheckedfree: isSwitchCheckedfree.value,
        startDate: selectedDate.value != null
            ? "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}"
            : 'No date selected',
        interest: double.parse(totalInterest.value),
        totalAmount: double.parse(totalAmount.value),
        prePayAmount: prePayAmountController.value.text,
        depositType: dropdownValueDeposit.value,
        emiAmount: emiAmount.value,
        extraPay: extraPayment.value,
        feesCharges: fee.value,
        principleAmount: double.tryParse(principleAmount.value) ?? 0.0,
      );
      if (updateBtn.value == false) {
        // addLoan();
        loans.add(loan);
        await saveLoansToStorage();

        log('loans${loans}');
        updateBtn.value = true;
        // Clear form fields
        clear();
      } else {
        loans[index]=loan;
        await saveLoansToStorage();
        updateBtn.value = false;
        // updateLoan(index);
      }
      // log('index==>>${index.value}');
      // log('updateIndex==>>${updateIndex.value}');
     /* if(index.value==1){
        loans[updateIndex.value] = loan;
        index.value=0;

      }else{

        loans.add(loan);
        await saveLoansToStorage();
      }*/
      // Get.off(() => Calculation());
    }


  }
 /* void addLoan() async {
    double loanAmountVal = double.tryParse(loanAmountController.value.text) ?? 0.0;
    double annualRateVal = double.tryParse(annualRateController.value.text) ?? 0.0;
    int tenureVal = int.tryParse(tenureController.value.text) ?? 0;
    double feeVal = double.tryParse(feeController.value.text) ?? 0.0;
    double prePayAmountVal = double.tryParse(prePayAmountController.value.text) ?? 0.0;

    double r = annualRateVal / 100 / 12;
    int n = tenureVal * (isSwitchChecked.value ? 12 : 1);

    if (loanAmountVal <= 0 || annualRateVal <= 0 || tenureVal <= 0) {
      emiAmount.value = "Invalid input";
      return;
    }

    // Initial EMI Calculation
    double emi = (loanAmountVal * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
    double totalInterestVal = emi * n - loanAmountVal;
    double totalAmountVal = loanAmountVal + totalInterestVal;
    double feeAmount = isSwitchCheckedfree.value ? (loanAmountVal * feeVal / 100) : feeVal;
    double extraPaymentVal = isChecked.value ? prePayAmountVal : 0.0;

    emiAmount.value = emi.toStringAsFixed(0);
    totalInterest.value = totalInterestVal.toStringAsFixed(0);
    totalAmount.value = totalAmountVal.toStringAsFixed(0);
    fees.value = feeAmount.toStringAsFixed(0);
    extraPayment.value = extraPaymentVal.toStringAsFixed(0);

    log("emiAmount${emiAmount}");
    log("totalInterest${totalInterest}");
    log("totalAmount${totalAmount}");
    log("fees${fees}");
    log("extraPayment${extraPayment}");

    // Apply prepayment to the loan balance
    double remainingLoanBalance = loanAmountVal;
    DateTime currentDate = selectedDate.value;

    // Track the total extra payment made across the entire loan tenure
    double totalExtraPayment = 0.0;

    // List to hold the adjusted schedule with prepayment applied
    List<Map<String, dynamic>> adjustedSchedule = [];
    for (int month = 1; month <= n; month++) {
      // Calculate the interest for this month
      double interestForMonth = remainingLoanBalance * r;

      // Apply prepayment if checked (at the start of the month)
      if (extraPaymentVal > 0) {
        remainingLoanBalance -= extraPaymentVal;
        if (remainingLoanBalance < 0) remainingLoanBalance = 0;
        totalExtraPayment += extraPaymentVal;  // Accumulate extra payments
      }

      // Calculate the principal and new remaining balance
      double principalForMonth = emi - interestForMonth;
      remainingLoanBalance -= principalForMonth;
      if (remainingLoanBalance < 0) remainingLoanBalance = 0;

      // Create a record for this month in the adjusted schedule
      adjustedSchedule.add({
        'month': month,
        'emi': emi,
        'interest': interestForMonth,
        'principal': principalForMonth,
        'remainingBalance': remainingLoanBalance,
      });

      // Move to the next month
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    // After the loop, adjust totals and breakdown
    double totalPrincipal = 0;
    double totalInterestPaid = 0;
    for (var record in adjustedSchedule) {
      totalPrincipal += record['principal'];
      totalInterestPaid += record['interest'];
    }

    totalAmount.value = (totalPrincipal + totalInterestPaid).toStringAsFixed(0);
    totalInterest.value = totalInterestPaid.toStringAsFixed(0);
    totalAmount.value = totalAmount.value;

    // Adjust total extra payment to reflect the correct amount
    totalExtraPayment = min(totalExtraPayment, 1900); // Limit extra payment to 1900
    extraPayment.value=totalExtraPayment.toStringAsFixed(0);
    log("Total Extra Payment: ₹${totalExtraPayment.toStringAsFixed(0)}");
    Loan loan = Loan( feesCharges: fee.value,
      loanAmount: loanAmountController.value.text,
      annualRate: annualRateController.value.text,
      tenure: tenureController.value.text,
      fee: feeController.value.text,
      note: noteController.value.text,
      isPrePaymentChecked: isChecked.value,
      isSwitchChecked: isSwitchChecked.value,
      isSwitchCheckedfree: isSwitchCheckedfree.value,
      startDate: selectedDate.value != null
          ? "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}"
          : 'No date selected',
      interest: double.parse(totalInterest.value),
      totalAmount: double.parse(totalAmount.value),
      prePayAmount: prePayAmountController.value.text,
      depositType: dropdownValueDeposit.value,
      emiAmount: emiAmount.value,principleAmount: totalPrincipal,
      extraPay: extraPayment.value,
    );

    loans.add(loan);
    await saveLoansToStorage();
log('loans${loans}');
    // Clear form fields
    clear();
  }*/
  /*void updateLoan(int index) async {
    // Parse the edited user inputs
    double loanAmount = double.tryParse(loanAmountController.value.text) ?? 0.0;
    double annualRate = double.tryParse(annualRateController.value.text) ?? 0.0;
    int tenure = int.tryParse(tenureController.value.text) ?? 0;

    // Calculate interest and total amount
    double interest = (loanAmount * annualRate * tenure) / 100;
    double totalAmount = loanAmount + interest;

    // Update the loan at the specified index
    loans[index] = Loan( feesCharges: fee.value,
      loanAmount: loanAmountController.value.text,
      annualRate: annualRateController.value.text,
      tenure: tenureController.value.text,
      fee: feeController.value.text,
      note: noteController.value.text,
      isPrePaymentChecked: isChecked.value,
      isSwitchChecked: isSwitchChecked.value,
      isSwitchCheckedfree: isSwitchCheckedfree.value,
      startDate: "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}",
      interest: interest,
      totalAmount: totalAmount,
      depositType: dropdownValueDeposit.value,
      prePayAmount: prePaidAmount.value, extraPay: extraPayment.value,principleAmount: double.parse(totalPrincipal.value)
    );

    await saveLoansToStorage();
    updateBtn.value = false;  // Reset the update button
    clear();  // Clear form fields after update
  }*/

  void clear() {
    loanAmountController.value.clear();
    prePayAmountController.value.clear();
    annualRateController.value.clear();
    tenureController.value.clear();
    feeController.value.clear();
    noteController.value.clear();
    isChecked.value = false;
    isSwitchChecked.value = false;
    isSwitchCheckedfree.value = false;
    dropdownValueDeposit.value = 'Monthly';
  }

  Future<void> saveLoansToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final loanListJson = jsonEncode(
        loans.map((loan) => loan.toJson()).toList());
    await prefs.setString('loans', loanListJson);
  }
  Future<void> loadLoansFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final loanListJson = prefs.getString('loans');

    if (loanListJson != null) {
      final loanList = jsonDecode(loanListJson) as List;
      loans.value = loanList.map((loanJson) => Loan.fromJson(loanJson)).toList();
    }
  }

  // for LoanEmi compareBtn Save
  Future<void> addLoanFromCompare(Loan loan) async {
    loans.add(loan);
    await saveLoansToStorage();

    log('Loan added to comparison and saved to storage');
  }
}