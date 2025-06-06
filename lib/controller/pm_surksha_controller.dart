import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PmSurkshaController extends GetxController {
  Rx<TextEditingController> yearController = TextEditingController().obs;
  RxString year = ''.obs;
  RxString ageError = ''.obs;
RxBool isValueShow=false.obs;
  RxInt contributionPeriod = 0.obs;
  RxDouble yearlyContribution = 20.0.obs;
  RxDouble totalContribution = 0.0.obs;

  void calculateContribution() {
    isValueShow.value=true;
    if (year.value.isNotEmpty) {
      int? age = int.tryParse(year.value);
      if (age != null && age >= 18 && age <= 70) {
        // Calculate contribution details
        contributionPeriod.value = 70 - age; // 70 years minus entered age
        totalContribution.value = yearlyContribution.value * contributionPeriod.value;
        ageError.value = ''; // Clear the error
      } else {
        ageError.value = 'Age must be between 18 and 70 years.';
        contributionPeriod.value = 0;
        totalContribution.value = 0.0;
      }
    } else {
      ageError.value = 'Please enter your Age';
      contributionPeriod.value = 0;
      totalContribution.value = 0.0;
    }
  }

  void clear() {
    isValueShow.value=false;
    yearController.value.clear(); // Clear the TextEditingController
    year.value = ''; // Clear the year value
    ageError.value = ''; // Clear the error message
    contributionPeriod.value = 0; // Reset contribution period
    totalContribution.value = 0.0; // Reset total contribution
  }
}
