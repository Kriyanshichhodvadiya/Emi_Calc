import 'package:emi_calc/common/cash_counter_common.dart';
import 'package:emi_calc/common/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

import '../common/rd_cal_common.dart';
import '../config/color.dart';
import '../controller/cash_counter_controller.dart';

class CashCounter extends StatelessWidget {
  CashCounter({super.key});
  CashCounterController controller = Get.put(CashCounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: commonappbar(text: "Cash Counter"),
      body: SingleChildScrollView(
        child: Padding(
          padding: 20.symmetric,
          child: Column(
            children: [
              Obx(
                () => countRow(
                  rs: "2000",
                  rsTotal: "${controller.totalOne.value}",
                  controller: controller.noteOneController.value,
                  onChanged: (value) {
                    controller.none.value = value;
                    controller.calculateTotal(
                        2000, controller.none, controller.totalOne);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "500",
                  rsTotal: "${controller.totalTwo.value}",
                  controller: controller.noteTwoController.value,
                  onChanged: (value) {
                    controller.nTwo.value = value;
                    controller.calculateTotal(
                        500, controller.nTwo, controller.totalTwo);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "200",
                  rsTotal: "${controller.totalThree.value}",
                  controller: controller.noteThreeController.value,
                  onChanged: (value) {
                    controller.nThree.value = value;
                    controller.calculateTotal(
                        200, controller.nThree, controller.totalThree);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "100",
                  rsTotal: "${controller.totalFour.value}",
                  controller: controller.noteFourController.value,
                  onChanged: (value) {
                    controller.nFour.value = value;
                    controller.calculateTotal(
                        100, controller.nFour, controller.totalFour);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "50",
                  rsTotal: "${controller.totalFive.value}",
                  controller: controller.noteFiveController.value,
                  onChanged: (value) {
                    controller.nFive.value = value;
                    controller.calculateTotal(
                        50, controller.nFive, controller.totalFive);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "20",
                  rsTotal: "${controller.totalSix.value}",
                  controller: controller.noteSixController.value,
                  onChanged: (value) {
                    controller.nSix.value = value;
                    controller.calculateTotal(
                        20, controller.nSix, controller.totalSix);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "10",
                  rsTotal: "${controller.totalSeven.value}",
                  controller: controller.noteSevenController.value,
                  onChanged: (value) {
                    controller.nSeven.value = value;
                    controller.calculateTotal(
                        10, controller.nSeven, controller.totalSeven);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "5",
                  rsTotal: "${controller.totalEight.value}",
                  controller: controller.noteEightController.value,
                  onChanged: (value) {
                    controller.nEight.value = value;
                    controller.calculateTotal(
                        5, controller.nEight, controller.totalEight);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "2",
                  rsTotal: "${controller.totalNine.value}",
                  controller: controller.noteNineController.value,
                  onChanged: (value) {
                    controller.nNine.value = value;
                    controller.calculateTotal(
                        2, controller.nNine, controller.totalNine);
                  },
                ),
              ),
              15.height,
              Obx(
                () => countRow(
                  rs: "1",
                  rsTotal: "${controller.totalTen.value}",
                  controller: controller.noteTenController.value,
                  onChanged: (value) {
                    controller.nTen.value = value;
                    controller.calculateTotal(
                        1, controller.nTen, controller.totalTen);
                  },
                ),
              ),
              20.height,
              Container(
                padding: 20.symmetric,
                width: double.maxFinite,
                decoration:commonDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Obx(() => Text(
                            "Total Amount: ${controller.grandTotal.value} ₹",
                            style: style(
                                color: AppColors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                    Divider(
                      height: 30,
                      color: AppColors.greylight,
                    ),
                    Obx(() => rdCalRow(
                        text: "Notes",
                        amount: "${controller.calculateAllNotesTotal()}")),
                    Divider(
                      height: 30,
                      color: AppColors.greylight,
                    ),
                    Text(
                      "In English",
                      style: style(
                          fontSize: 10,
                          color: AppColors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                    ),
                    5.height,
                    Obx(() {
                      String toTitleCase(String text) {
                        if (text.isEmpty) return text;
                        return text
                            .split(' ')
                            .map((word) =>
                                word[0].toUpperCase() +
                                word.substring(1).toLowerCase())
                            .join(' ');
                      }

                      String formattedText = toTitleCase(
                          NumberToWordsEnglish.convert(
                              controller.grandTotal.value));

                      return Text(
                        controller.grandTotal.value > 0
                            ? "$formattedText Rupee Only"
                            : "Zero",
                        style: style(
                            fontSize: 12,
                            color: AppColors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w600),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
