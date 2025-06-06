import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GstCalController extends GetxController {
  Rx<TextEditingController> amountController = TextEditingController().obs;
  Rx<TextEditingController> gstRateController = TextEditingController().obs;
  RxString amount = ''.obs;
  RxString gstRate = ''.obs;

  RxString bgroup = 'Add GST (+)'.obs;
  RxString amountBeforeGST = ''.obs;
  RxString gstAmount = ''.obs;
  RxString totalAmount = ''.obs;
  RxBool afterTextShow=false.obs;
  RxBool isValueShow=false.obs;
  void calculateGST() {
    // Parse input values
    isValueShow.value=true;
    double amount = double.tryParse(this.amount.value) ?? 0.0;
    double gstRate = double.tryParse(this.gstRate.value) ?? 0.0;

    // Validate input values
    if (amount <= 0 || gstRate <= 0) {
      log("Invalid input: Amount and GST rate must be greater than zero.");
      return;
    }

    // GST amount calculation
    double gstAmount = (amount * gstRate) / 100;

    if (bgroup.value == "Add GST (+)") {
      // Add GST to the original amount
      afterTextShow.value=false;
      double totalAmount = amount + gstAmount;
      amountBeforeGST.value = amount.toStringAsFixed(0);
      this.gstAmount.value = gstAmount.toStringAsFixed(0);
      this.totalAmount.value = totalAmount.toStringAsFixed(0);
    } else if (bgroup.value == "Subtract GST (-)") {
      // Calculate the amount before GST
      afterTextShow.value=true;
      double amountBeforeGST = amount / (1 + gstRate / 100);
      gstAmount = amount - amountBeforeGST;
      this.amountBeforeGST.value = amountBeforeGST.toStringAsFixed(0);
      this.gstAmount.value = gstAmount.toStringAsFixed(0);
      totalAmount.value = amount.toStringAsFixed(0);
    }

    // Log results for debugging
    log("Amount: $amount");
    log("GST Rate: $gstRate");
    log("Amount Before GST: ${this.amountBeforeGST.value}");
    log("GST Amount: ${this.gstAmount.value}");
    log("Total Amount: ${this.totalAmount.value}");
  }
  void clear() {

    amountController.value.clear();
    gstRateController.value.clear();

    amount.value = '';
    gstRate.value = '';

    amountBeforeGST.value = '';
    gstAmount.value = '';
    totalAmount.value = '';

    afterTextShow.value = false;
    isValueShow.value = false;bgroup.value = 'Add GST (+)';

    log("All fields and values have been cleared.");
  }
}
