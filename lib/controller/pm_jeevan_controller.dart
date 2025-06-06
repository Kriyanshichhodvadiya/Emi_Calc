import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PmJeevanController extends GetxController {
  Rx<TextEditingController> yearController = TextEditingController().obs;
  RxString ageError = ''.obs;
  RxString year = ''.obs;
RxBool isValueShow=false.obs;
  RxInt contributionPeriod = 0.obs;
  RxDouble yearlyContribution = 436.0.obs;
  RxDouble totalContribution = 0.0.obs;
  void calculate() {
    try {
      isValueShow.value=true;
      int age = int.parse(year.value);



      contributionPeriod.value = 50 - age;
      totalContribution.value = yearlyContribution.value * contributionPeriod.value;
    } catch (e) {

     contributionPeriod.value = 0;
      totalContribution.value = 0.0;
    }
  }
  void clear() {
    isValueShow.value=false;
    yearController.value.clear();
    year.value = '';
    contributionPeriod.value = 0;
    totalContribution.value = 0.0;
  }

}
