import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicProvidentController extends GetxController {
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
}
