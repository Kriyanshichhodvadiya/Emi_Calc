import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashCounterController extends GetxController {
  Rx<TextEditingController> noteOneController = TextEditingController().obs;
  Rx<TextEditingController> noteTwoController = TextEditingController().obs;
  Rx<TextEditingController> noteThreeController = TextEditingController().obs;
  Rx<TextEditingController> noteFourController = TextEditingController().obs;
  Rx<TextEditingController> noteFiveController = TextEditingController().obs;
  Rx<TextEditingController> noteSixController = TextEditingController().obs;
  Rx<TextEditingController> noteSevenController = TextEditingController().obs;
  Rx<TextEditingController> noteEightController = TextEditingController().obs;
  Rx<TextEditingController> noteNineController = TextEditingController().obs;
  Rx<TextEditingController> noteTenController = TextEditingController().obs;

  RxString none = ''.obs;
  RxString nTwo = ''.obs;
  RxString nThree = ''.obs;
  RxString nFour = ''.obs;
  RxString nFive = ''.obs;
  RxString nSix = ''.obs;
  RxString nSeven = ''.obs;
  RxString nEight = ''.obs;
  RxString nNine = ''.obs;
  RxString nTen = ''.obs;
  RxInt totalOne = 0.obs;
  RxInt totalTwo = 0.obs;
  RxInt totalThree = 0.obs;
  RxInt totalFour = 0.obs;
  RxInt totalFive = 0.obs;
  RxInt totalSix = 0.obs;
  RxInt totalSeven = 0.obs;
  RxInt totalEight = 0.obs;
  RxInt totalNine = 0.obs;
  RxInt totalTen = 0.obs;
  RxInt grandTotal = 0.obs;

  String calculateAllNotesTotal() {
    int sum = 0;

    // Parse each RxString and add its integer value to the sum
    sum += int.tryParse(none.value) ?? 0;
    sum += int.tryParse(nTwo.value) ?? 0;
    sum += int.tryParse(nThree.value) ?? 0;
    sum += int.tryParse(nFour.value) ?? 0;
    sum += int.tryParse(nFive.value) ?? 0;
    sum += int.tryParse(nSix.value) ?? 0;
    sum += int.tryParse(nSeven.value) ?? 0;
    sum += int.tryParse(nEight.value) ?? 0;
    sum += int.tryParse(nNine.value) ?? 0;
    sum += int.tryParse(nTen.value) ?? 0;

    return "${sum}";
  }
  void calculateTotal(int rupees, RxString controller, RxInt total) {
    int count = int.tryParse(controller.value) ?? 0;
    total.value = count * rupees;
    calculateGrandTotal();
    calculateAllNotesTotal();
  }

  void calculateGrandTotal() {
    grandTotal.value = totalOne.value +
        totalTwo.value +
        totalThree.value +
        totalFour.value +
        totalFive.value +
        totalSix.value +
        totalSeven.value +
        totalEight.value +
        totalNine.value +
        totalTen.value;
  }


  void clear() {
    noteOneController.value.clear();
    noteTwoController.value.clear();
    noteThreeController.value.clear();
    noteFourController.value.clear();
    noteFiveController.value.clear();
    noteSixController.value.clear();
    noteSevenController.value.clear();
    noteEightController.value.clear();
    noteNineController.value.clear();
    noteTenController.value.clear();

    none.value = '';
    nTwo.value = '';
    nThree.value = '';
    nFour.value = '';
    nFive.value = '';
    nSix.value = '';
    nSeven.value = '';
    nEight.value = '';
    nNine.value = '';
    nTen.value = '';

    totalOne.value = 0;
    totalTwo.value = 0;
    totalThree.value = 0;
    totalFour.value = 0;
    totalFive.value = 0;
    totalSix.value = 0;
    totalSeven.value = 0;
    totalEight.value = 0;
    totalNine.value = 0;
    totalTen.value = 0;

    grandTotal.value = 0;
  }

}
