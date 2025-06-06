import 'dart:developer';

import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgeCalController extends GetxController {
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);  // Allow null value
  Rx<DateTime?> birthDate = Rx<DateTime?>(null);
  RxInt ageYears = 0.obs;
  RxInt ageMonths = 0.obs;
  RxInt ageDays = 0.obs;
  RxInt ageWeeks = 0.obs;
  RxInt ageHours = 0.obs;
  RxInt ageMinutes = 0.obs;
  RxInt ageSeconds = 0.obs;
  RxBool isValueShow=false.obs;
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
    if (picked != null) {
      selectedDate.value = picked; // Update the selected date
    }
  }

  Future<void> birthSelectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now(); // Get the current date

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Set the initial date to today's date
      firstDate:
          DateTime(2000), // Allow selecting dates from the year 2000 onward
      lastDate: currentDate, // Prevent selecting future dates
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

    // If a date is picked, update the birthDate value, otherwise leave it unchanged
    if (picked != null) {
      birthDate.value = picked; // Update the selected date
    }
  }
  void calculateAge() {
    isValueShow.value = true;
    final DateTime? startDate = birthDate.value;
    final DateTime? endDate = selectedDate.value;

    if (endDate!.isBefore(startDate!)) {
      log("Invalid dates: 'Age as on' date cannot be earlier than birth date.");
      return;
    }

    // Calculate the difference in years, months, and days
    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;
    int days = endDate.day - startDate.day;

    // Adjust for negative days/months
    if (days < 0) {
      months -= 1;
      days += DateTime(endDate.year, endDate.month, 0).day; // Days in the previous month
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    // Total age in days
    int totalDays = endDate.difference(startDate).inDays;

    // Calculate other metrics
    ageYears.value = years;
    ageMonths.value = years * 12 + months;
    ageDays.value = totalDays;
    ageWeeks.value = totalDays ~/ 7;
    ageHours.value = totalDays * 24;

    // Calculate age in minutes by considering the exact time
    int totalMinutes = endDate.difference(startDate).inMinutes;
    ageMinutes.value = totalMinutes;

    // Calculate age in seconds by considering the exact time
    int totalSeconds = endDate.difference(startDate).inSeconds;
    ageSeconds.value = totalSeconds;

    // Log for debugging
    log("Years: $years, Months: $months, Days: $days");
    log("Total Days: $totalDays, Weeks: ${ageWeeks.value}, Hours: ${ageHours.value}");
    log("Minutes: $totalMinutes, Seconds: $totalSeconds");

    // Add current time to make sure the age is up-to-date
    int currentSeconds = DateTime.now().difference(startDate).inSeconds;
    ageSeconds.value = currentSeconds;

    log("Age in exact seconds: $currentSeconds");
  }
  void clear() {

    selectedDate.value = null;
    birthDate.value = null;

    ageYears.value = 0;
    ageMonths.value = 0;
    ageDays.value = 0;
    ageWeeks.value = 0;
    ageHours.value = 0;
    ageMinutes.value = 0;
    ageSeconds.value = 0;

    isValueShow.value = false;

  }


}
