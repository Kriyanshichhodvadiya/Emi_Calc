import 'package:emi_calc/common/amount_toword_common.dart';
import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/images.dart';
import 'package:emi_calc/controller/amount_toword_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

import '../config/color.dart';

class AmountToword extends StatelessWidget {
  AmountToword({super.key});
  AmountToWordController controller = Get.put(AmountToWordController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Amount To Words"),
      body: SingleChildScrollView(
        child: Padding(
          padding: 10.horizontal,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                20.height,
                commonTextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  img: AppImages.rs,
                  controller: controller.monthInvestController.value,
                  onChanged: (value) {
                    controller.monthInvest.value = value;
                  },
                  keyboardType: TextInputType.number,
                  text: "Enter Amount",
                  label: "Amount",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    return null;
                  },
                ),
                30.height,
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Text("")),
                    Expanded(
                      child: primarybutton(
                        color: AppColors.black,
                        backgroundColor: AppColors.white,
                        text: "clear",
                        onPressed: () {
                          controller.clear();
                        },
                      ),
                    ),
                    Expanded(child: Text("")),
                  ],
                ),
                20.height,
                Obx(
                  () => Visibility(
                    visible: controller.monthInvest.value.isNotEmpty,
                    child: countryAmount(
                      countryname: "Indian Format",
                      amount: "₹ ${controller.monthInvest.value}",
                      text: controller.monthInvest.value.isEmpty
                          ? ""
                          : "${controller.toTitleCase(NumberToWordsEnglish.convert(int.parse(controller.monthInvest.value)))} Rupee Only",
                    ),
                  ),
                ),
                20.height,
                Obx(
                  () => Visibility(
                    visible: controller.monthInvest.value.isNotEmpty,
                    child: countryAmount(
                      countryname: "US Format",
                      amount: "\$ ${controller.monthInvest.value}",
                      text: controller.monthInvest.value.isEmpty
                          ? ""
                          : "${controller.toTitleCase(NumberToWordsEnglish.convert(int.parse(controller.monthInvest.value)))} Dollar Only",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
