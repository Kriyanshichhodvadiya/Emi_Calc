import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'dart:typed_data';
import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/controller/new_calculation_controller.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/loan_model.dart';
import '../view/calculation.dart';
import 'loamcompare_add_controller.dart';

class NewCalculationController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  Rx<TextEditingController> feeController = TextEditingController().obs;
  Rx<TextEditingController> noteController = TextEditingController().obs;
  Rx<TextEditingController> prePayAmountController =
      TextEditingController().obs;

  RxString loanAmount = '10000'.obs;
  RxString annualRate = '12'.obs;
  RxString tenure = '2'.obs;
  RxString fee = ''.obs;
  RxString note = ''.obs;
  RxString prePaidAmount = ''.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> startFrom = DateTime.now().obs;
  RxString dropdownValueDeposit = 'Monthly'.obs;
  RxBool isChecked = false.obs;
  RxBool updateBtn=false.obs;
  RxBool isSwitchChecked = false.obs;
  RxBool isSwitchCheckedfree = false.obs;
  RxString emiAmount = '10000'.obs;
  RxString totalInterest = ''.obs;
  RxString totalAmount = '200'.obs; RxString principleAmount = '0'.obs;
  RxString fees = ''.obs;
  RxString extraPayment = ''.obs;
  List<String> depositType = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];
  RxInt index=0.obs;
  RxList<Loan> loans = <Loan>[].obs;
  RxList<Loan> compareLoans = <Loan>[].obs;
  final selectedYear = RxnString();
  @override
  void onInit() {
    getLoanData();
    super.onInit();
  }
  var selectedIndex = 0.obs;
  var updateIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
 /* void onCompareButtonTap(int index) {
    LoanCompareAddController controller = Get.put(LoanCompareAddController());
    controller.addLoanFromCompareByIndex(index);
  }*/
  RxList<Map<String, dynamic>> emiSchedule = <Map<String, dynamic>>[].obs;
  RxMap<int, double> yearlyPrincipal = <int, double>{}.obs;
  void calculateEMIBreakdown({
    required bool isTenureInYears,
    required String tenure,
  })
  {
    double tenureInDouble = double.tryParse(tenure) ?? 0.0;
    // Determine total months based on tenure type
    int totalMonths = isTenureInYears ? (tenureInDouble * 12).toInt() : tenureInDouble.toInt();

    // Monthly interest rate
    double monthlyInterestRate = (double.tryParse(annualRate.value) ?? 0.0) / 100 / 12;

    // EMI formula: EMI = [P * r * (1 + r)^n] / [(1 + r)^n - 1]
    double emiValue = (double.tryParse(loanAmount.value) ?? 0.0) *
        monthlyInterestRate *
        (pow(1 + monthlyInterestRate, totalMonths)) /
        (pow(1 + monthlyInterestRate, totalMonths) - 1);

    double remainingBalance = double.tryParse(loanAmount.value) ?? 0.0;
    DateTime currentDate = selectedDate.value;

    // Clear previous schedule data
    emiSchedule.clear();
    yearlyPrincipal.clear();

    for (int month = 1; month <= totalMonths; month++) {
      // Calculate interest and principal components
      double interest = remainingBalance * monthlyInterestRate;
      double principal = emiValue - interest;
      remainingBalance -= principal;

      // Add principal to the respective year
      int year = currentDate.year;
      yearlyPrincipal.update(year, (value) => value + principal, ifAbsent: () => principal);

      // Format the date as "YYYY-MM"
      String formattedDate = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}";

      // Add to EMI schedule
      emiSchedule.add({
        'year': currentDate.year,
        'month': formattedDate,
        'principal': principal,
        'interest': interest,
        'emi': emiValue,
        'remainingBalance': remainingBalance < 0 ? 0 : remainingBalance,
      });

      // Move to the next month
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    // Log yearly principal breakdown for debugging
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
      selectedDate.value = picked;
    }
  }
  Future<void> startFromDate(BuildContext context) async {
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
      startFrom.value = picked;
    }
  }

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
    log('index==>>${index.value}');
    log('updateIndex==>>${updateIndex.value}');
      if(index.value==1){
        loans[updateIndex.value] = loan;
        index.value=0;

      }else{

        loans.add(loan);
        await saveLoansToStorage();
      }
      selectedIndex.value=0;
      Get.off(() => Calculation());
    }


  }
  Future<void> saveLoansToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final loanListJson =
        jsonEncode(loans.map((loan) => loan.toJson()).toList());
    await prefs.setString('emiLoans', loanListJson);
  }

  Future<void> getLoanData() async {
    final prefs = await SharedPreferences.getInstance();
    final loanListJson = prefs.getString('emiLoans');

    if (loanListJson != null) {
      final loanList = jsonDecode(loanListJson) as List;
      loans.value =
          loanList.map((loanJson) => Loan.fromJson(loanJson)).toList();
    }
  }
  void clear() {
    loanAmountController.value.clear();
    annualRateController.value.clear();
    tenureController.value.clear();
    feeController.value.clear();
    noteController.value.clear();
    prePayAmountController.value.clear();
    loanAmount.value='';
    annualRate.value='';
    tenure.value='';
    fees.value='';
    note.value='';
    prePaidAmount.value='';
    selectedDate.value = DateTime.now();
    isChecked.value = false;
    isSwitchChecked.value = false;
    isSwitchCheckedfree.value = false;
  }
  Future<void> deleteLoan(int index) async {
    try {
      // Remove the loan from the list
      loans.removeAt(index);

      // Save the updated list to SharedPreferences
      await saveLoansToStorage();
    } catch (e) {
      log('Error deleting loan: $e');
    }
  }
  // Function to convert year-month format to month name
  String getMonthName(String yearMonth) {
    Map<String, String> monthMap = {
      "01": "Jan",
      "02": "Feb",
      "03": "Mar",
      "04": "Apr",
      "05": "May",
      "06": "Jun",
      "07": "Jul",
      "08": "Aug",
      "09": "Sep",
      "10": "Oct",
      "11": "Nov",
      "12": "Dec",
    };

    String month = yearMonth.split('-')[1];
    return monthMap[month] ?? "Invalid Month";
  }
  Map<String, Map<String, double>> getYearlyData() {
    Map<String, Map<String, double>> yearlyData = {};

    for (var item in emiSchedule) {
      String year = item['year'].toString();

      if (!yearlyData.containsKey(year)) {
        yearlyData[year] = {
          'principal': 0.0,
          'interest': 0.0,
          'totalAmount': 0.0,
          'remainingBalance': 0.0,
        };
      }
      yearlyData[year]!['principal'] = yearlyData[year]!['principal']! +
          (item['principal'] is double ? item['principal'] : (item['principal'] as num).toDouble());

      yearlyData[year]!['interest'] = yearlyData[year]!['interest']! +
          (item['interest'] is double ? item['interest'] : (item['interest'] as num).toDouble());

      yearlyData[year]!['totalAmount'] = yearlyData[year]!['totalAmount']! +
          ((item['principal'] + item['interest']) is double
              ? (item['principal'] + item['interest'])
              : (item['principal'] + item['interest']) as num).toDouble();

    // Take the last balance for the year
    yearlyData[year]!['remainingBalance'] = (item['remainingBalance'] is double
    ? item['remainingBalance']
        : (item['remainingBalance'] as num).toDouble());
    }

    return yearlyData;
    }
  List<Map<String, dynamic>> getMonthlyDataForYear(String year) {
    return emiSchedule
        .where((item) => item['year'].toString() == year)
        .toList();
  }
  void changeYear(bool isNext) {
    final allYears = getYearlyData().keys.toList();
    if (selectedYear.value != null) {
      int currentIndex = allYears.indexOf(selectedYear.value!);
      if (isNext && currentIndex < allYears.length - 1) {
        selectedYear.value = allYears[currentIndex + 1];
      } else if (!isNext && currentIndex > 0) {
        selectedYear.value = allYears[currentIndex - 1];
      }
    }
  }
}



class PdfGenerator {
   NewCalculationController controller = Get.find();

  Future<void> generateAndSharePdf() async {
    final pdf = pw.Document();

    // 1st Page: Total Amount and Loan Details
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Loan Summary", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _createLoanDetails(),
            ],
          );
        },
      ),
    );

    // 2nd Page: Payment Schedule Table
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Payment Schedule", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _createPaymentScheduleTable(),
            ],
          );
        },
      ),
    );

    // Additional Pages: Yearly & Monthly Breakdown
    final yearlyData = controller.getYearlyData();
    for (var year in yearlyData.keys) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text("Yearly Report: $year", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                _createYearlyBreakdown(year),
              ],
            );
          },
        ),
      );

      // Monthly Report for the Year
      final monthlyData = controller.getMonthlyDataForYear(year);
      for (var monthData in monthlyData) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Text("Monthly Report: ${controller.getMonthName(monthData['month'])}", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  _createMonthlyBreakdown(monthData),
                ],
              );
            },
          ),
        );
      }
    }

    // Save and Share the PDF
    await _savePdfToStorage(pdf);
  }


  pw.Widget _createLoanDetails() {
    return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
    pw.Text("Loan EMI Details", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
    pw.Divider(),
      pw.Text("Total Amount${controller.totalAmount.value}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      pw.Text("A+B+C+D", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),

    pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Loan Amount")),pw.Expanded(flex: 5,child: pw.Text("${controller.loanAmount.value} Rs."))]),
   pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Annual Interest Rate")),pw.Expanded(flex: 5,child: pw.Text("${controller.annualRate.value} Rs."))]),
   pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Extra Payment")),pw.Expanded(flex: 5,child: pw.Text("${controller.extraPayment.value} Rs."))]),
   pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Fees & Charges")),pw.Expanded(flex: 5,child: pw.Text("${controller.fees.value} Rs."))]),
   pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Loan Start Date")),pw.Expanded(flex: 5,child: pw.Text("${controller.selectedDate}"))]),
   pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("EMI Amount")),pw.Expanded(flex: 5,child: pw.Text("${controller.emiAmount.value} Rs."))]),
   pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Interest Rate")),pw.Expanded(flex: 5,child: pw.Text("${controller.annualRate.value}${controller.isSwitchChecked.value ? "Amount":"%"}"))]),
   pw.Row(children: [pw.Expanded(flex: 1,child: pw.Text("Tenure")),pw.Expanded(flex: 5,child: pw.Text("${controller.isSwitchChecked.value ? '${int.parse(controller.tenure.value) * 12}' : '${controller.tenure.value}'}"))]),
   ],
   )


   ;
  }

  pw.Widget _createPaymentScheduleTable() {
    final data = controller.emiSchedule; // Assuming this data is already available
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            _createTableCell("Principal (A)"),
            _createTableCell("Interest (B)"),
            _createTableCell("Total (A+B)"),
            _createTableCell("Remaining Balance"),
            _createTableCell("Year"),
          ],
        ),
        for (var entry in data)
          pw.TableRow(
            children: [
              _createTableCell(entry['principal'].toString()),
              _createTableCell(entry['interest'].toString()),
              _createTableCell(entry['totalAmount'].toString()),
              _createTableCell(entry['remainingBalance'].toString()),
              _createTableCell(entry['year'].toString()),
            ],
          ),
      ],
    );
  }

  pw.Widget _createYearlyBreakdown(String year) {
    final totals = controller.getYearlyData()[year];
    return pw.Column(
      children: [
        pw.Text("Year: $year"),
        pw.Text("Principal: ${totals!['principal']} Rs."),
        pw.Text("Interest: ${totals!['interest']} Rs."),
        pw.Text("Total: ${totals!['totalAmount']} Rs."),
        pw.Text("Remaining Balance: ${totals['remainingBalance']} Rs."),
      ],
    );
  }

  pw.Widget _createMonthlyBreakdown(Map<String, dynamic> monthData) {
    return pw.Column(
      children: [
        pw.Text("Principal: ${monthData['principal']} Rs."),
        pw.Text("Interest: ${monthData['interest']} Rs."),
        pw.Text("Total: ${monthData['principal'] + monthData['interest']} Rs."),
        pw.Text("Remaining Balance: ${monthData['remainingBalance']} Rs."),
        pw.Text("Month: ${controller.getMonthName(monthData['month'])}"),
      ],
    );
  }

  pw.Widget _createTableCell(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(4),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 12)),
    );
  }

  Future<void> _savePdfToStorage(pw.Document pdf) async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/loan_report.pdf");
    await file.writeAsBytes(await pdf.save());

    // Share the PDF file
    await Share.shareXFiles(
      [XFile(file.path)],  // Wrap the file path in XFile
      text: 'Loan Report',
    );
  }
}
