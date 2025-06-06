import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class VehicleController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  RxString loanAmount = ''.obs;
  RxString annualRate = ''.obs;
  RxString tenure = ''.obs;
  RxString bgroup = 'Standard'.obs;
  RxDouble emi = 0.0.obs;
  RxDouble totalPayableAmount = 0.0.obs;
  RxDouble totalInterestPayable = 0.0.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxString totalLoanWithInterest = ''.obs;
  RxBool isSwitchChecked = false.obs;
  RxBool isValueShow = false.obs;
  RxList<Map<String, dynamic>> emiSchedule = <Map<String, dynamic>>[].obs;
  RxMap<int, double> yearlyPrincipal = <int, double>{}.obs;
  final selectedYear = RxnString();
  // Adding the calculateEMIBreakdown method for EMI schedule calculation
  void calculateEMIBreakdown({
    required bool isTenureInYears,
    required double tenure,
  })
  {
    int totalMonths = isTenureInYears ? (tenure * 12).toInt() : tenure.toInt();

    double monthlyInterestRate = (double.tryParse(annualRate.value) ?? 0.0) / 100 / 12;
    double emiValue = (double.tryParse(loanAmount.value) ?? 0.0) *
        monthlyInterestRate *
        (pow(1 + monthlyInterestRate, totalMonths)) /
        (pow(1 + monthlyInterestRate, totalMonths) - 1);

    double remainingBalance = double.tryParse(loanAmount.value) ?? 0.0;
    DateTime currentDate = selectedDate.value;

    emiSchedule.clear(); // Clear existing schedule
    yearlyPrincipal.clear(); // Clear the yearly principal map to reset values

    for (int month = 1; month <= totalMonths; month++) {
      double interest = remainingBalance * monthlyInterestRate;
      double principal = emiValue - interest;
      remainingBalance -= principal;

      // Add principal to the respective year
      int year = currentDate.year;

      // Use 'update' to safely add or modify entries in the RxMap
      yearlyPrincipal.update(year, (value) => value + principal, ifAbsent: () => principal);

      // Format the date as "YYYY-MM"
      String formattedDate = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}";

      emiSchedule.add({
        'year': currentDate.year,
        'month': formattedDate,
        'principal': principal,
        'interest': interest,
        'emi': emiValue,
        'remainingBalance': remainingBalance < 0 ? 0 : remainingBalance,
      });

      // Update to the next month
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    // After all months are processed, log the total principal for each year
    yearlyPrincipal.forEach((year, totalPrincipal) {
      log("Total Principal for $year: $totalPrincipal");
    });
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
  void calculateEMI() {
    // Parse user inputs
    isValueShow.value=true;
    double principal = double.tryParse(loanAmount.value) ?? 0.0;
    double annualInterestRate = double.tryParse(annualRate.value) ?? 0.0;
    int tenureValue = int.tryParse(tenure.value) ?? 0;

    // Ensure inputs are valid
    if (principal <= 0 || annualInterestRate <= 0 || tenureValue <= 0) {
/*      Get.snackbar(
        'Invalid Input',
        'Please enter valid loan amount, interest rate, and tenure.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );*/
      return;
    }

    // Monthly interest rate
    double monthlyRate = annualInterestRate / 12 / 100;

    // Number of months in tenure
    int months = isSwitchChecked.value
        ? tenureValue * 12 // Convert years to months if switch is checked
        : tenureValue; // Use months directly

    // Calculate EMI for Standard scheme
    double emiValue = (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    // Calculate total payable amount and total interest
    double totalPayable = emiValue * months;
    double totalInterest = totalPayable - principal;

    if (bgroup.value == "Advance") {
      // Interest for Advance scheme calculated for the specified period (months)
      double advanceInterest = (principal * annualInterestRate * months) / (12 * 100);

      // Remove any old payable interest values, and log the correct Advance Interest
      log("Advance Interest (Calculated for $months months): $advanceInterest");

      // Total payable is principal + advance interest
      totalPayable = principal + advanceInterest;
      totalInterest = advanceInterest; // Total interest is the calculated advance interest
      emiValue = totalPayable / months; // EMI calculated based on total payable

      // Log for Advance scheme
      log("Total Payable (Advance): $totalPayable");
      log("Total Interest (Advance): $totalInterest");
      log("EMI Value (Advance): $emiValue");
    }

    // Update observables
    emi.value = emiValue;
    totalPayableAmount.value = totalPayable;
    totalInterestPayable.value = totalInterest;

    // Calculate and update totalLoanWithInterest (loanAmount + totalInterestPayable)
    double totalLoan = principal + totalInterest;
    totalLoanWithInterest.value = totalLoan.toStringAsFixed(2);  // Format as string

    print("Monthly EMI: $emiValue");
    print("Total Payable Amount: $totalPayable");
    print("Total Interest Payable: $totalInterest");
    print("Number of Payments: $months");
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    // Add a page with your data
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Vehicle Loan EMI Details", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Loan Amount")),pw.Expanded(flex: 5,child: pw.Text("${loanAmount.value} Rs."))]),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Annual Interest Rate")),pw.Expanded(flex: 5,child: pw.Text("${annualRate.value} Rs."))]),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Tenure")),pw.Expanded(flex: 5,child: pw.Text("{isSwitchChecked.value ? '${tenure.value} years' : '${tenure.value} months'}"))]),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Start Date")),pw.Expanded(flex: 5,child: pw.Text(" ${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}"))]),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("EMI Scheme")),pw.Expanded(flex: 5,child: pw.Text("${bgroup.value}"))]),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Monthly EMI")),pw.Expanded(flex: 5,child: pw.Text("${emi.value} Rs."))]),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Total Interest Payable: ")),pw.Expanded(flex: 5,child: pw.Text(" ${emi.value.toStringAsFixed(2)} Rs."))]),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Total Amount (Loan + Interest)")),pw.Expanded(flex: 5,child: pw.Text("${totalLoanWithInterest.value} Rs."))]),
              pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("No. of Payments")),pw.Expanded(flex: 5,child: pw.Text("${isSwitchChecked.value ? '${int.parse(tenure.value) * 12}' : '${tenure.value}'}"))]),
               ],
          );
        },
      ),
    );

    // Save PDF to local storage
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/VehicleLoanDetails.pdf");
    await file.writeAsBytes(await pdf.save());


    final xFile = XFile(file.path);    await Share.shareXFiles([xFile], text: "Vehicle Loan EMI Details");
  }
  void clear() {

    loanAmountController.value.clear();
    annualRateController.value.clear();
    tenureController.value.clear();
    loanAmount.value = '';
    annualRate.value = '';
    tenure.value = '';
    bgroup.value = 'Standard';
    emi.value = 0.0;
    totalPayableAmount.value = 0.0;
    totalInterestPayable.value = 0.0;
    selectedDate.value = DateTime.now();
    totalLoanWithInterest.value = '';
    isSwitchChecked.value = false;
    isValueShow.value = false;

  }


}

