import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanemiEditController extends GetxController {
  Rx<TextEditingController> loanAmountController = TextEditingController().obs;
  Rx<TextEditingController> annualRateController = TextEditingController().obs;
  Rx<TextEditingController> tenureController = TextEditingController().obs;
  Rx<TextEditingController> feeController = TextEditingController().obs;
  Rx<TextEditingController> noteController = TextEditingController().obs;
  Rx<TextEditingController> amountController = TextEditingController().obs;

  RxString loanAmount = ''.obs;
  RxString annualRate = ''.obs;
  RxString tenure = ''.obs;
  RxString fee = ''.obs;
  RxString note = ''.obs;
  RxString amount = ''.obs;
  List<String> depositType = [
    'Monthly Payout',
    'Quarterly Payout',
    'Half-Yearly Payout',
    'Yearly Payout',
    'Reinvestment (Cumulative)'
  ];

  RxString dropdownValueDeposit = 'Monthly Payout'.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> startSelectedDate = DateTime.now().obs;

  RxBool isChecked = false.obs;
  RxBool isSwitchChecked = false.obs;
  RxBool isSwitchCheckedfree = false.obs;

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

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarycolor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primarycolor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != startSelectedDate.value) {
      // Update the selectedDate observable
      startSelectedDate.value = picked;
    }
  }
}
