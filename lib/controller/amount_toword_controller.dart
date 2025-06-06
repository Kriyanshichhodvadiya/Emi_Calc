import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

class AmountToWordController extends GetxController {
  Rx<TextEditingController> monthInvestController = TextEditingController().obs;

  RxString monthInvest = ''.obs;


  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  void clear() {
    monthInvestController.value.clear();
    monthInvest.value = '';
  }




}
