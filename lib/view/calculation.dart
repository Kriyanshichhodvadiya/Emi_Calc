import 'dart:developer';

import 'package:emi_calc/controller/new_calculation_controller.dart';
import 'package:emi_calc/view/loan_details.dart';
import 'package:emi_calc/view/loanemi.dart';
import 'package:emi_calc/view/payment_schedule%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/common_widget.dart';
import '../config/color.dart';
import 'chart.dart';
import 'existing_amount.dart';
import 'extension.dart';
import 'home.dart';

class Calculation extends StatelessWidget {
  Calculation({super.key});
  NewCalculationController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    // var loan = controller.selectedLoan.value!;
    // log("Loan Amount: ${loan.loanAmount} ₹");
    // log("EMI Amount: ${loan.emiAmount} ₹");
    // log("Tenure: ${loan.tenure} ${loan.isSwitchChecked == false ? 'Month' : 'Year'}");
    // log("Interest Rate: ${loan.annualRate} ${loan.isSwitchCheckedfree == false ? '%' : '₹'}");
    // log("Note: ${loan.note.isEmpty ? 'N/A' : loan.note}");
    return WillPopScope(
      onWillPop: () async {
        // Get.back();
        Get.offAll(()=>LoanEmi());
        // controller.clear();
        return false;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColors.bgcolor,
          appBar: AppBar(surfaceTintColor: AppColors.primarycolor,
            leading: GestureDetector(
              onTap: () {
                // controller.clear();
                // Get.back();
                Get.offAll(()=>LoanEmi());
                // Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
              ),
            ),
            backgroundColor: AppColors.primarycolor,
            title: Text(
              "Calculation",
              style: style(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  PdfGenerator().generateAndSharePdf();
                },
                icon: Icon(
                  Icons.share,
                  color: AppColors.white,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Obx(
                () => Row(
                  children: [
                  tabBtn(
                        title: "Loan Details",
                        index: 0,
                        isSelect: controller.selectedIndex.value == 0,
                        onTap: () {
                          controller.changeTab(0);
                        },
                      ),

                   tabBtn(
                        title: "Payment Schedule",
                        index: 1,
                        isSelect: controller.selectedIndex.value == 1,
                        onTap: () {
                          controller.changeTab(1);
                        },
                      ),

                    tabBtn(
                        title: "Chart",
                        index: 2,
                        isSelect: controller.selectedIndex.value == 2,
                        onTap: () {
                          controller.changeTab(2);
                        },
                      ),

                  ],
                ),
              ),
            ),
          ),
          body: Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                LoanDetails(),
                PaymentSchedule(),
                Chart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget tabBtn(
    {required String title,
    required int index,
    required void Function()? onTap,
    required isSelect}) {
  // NewCalculationController controller=Get.find();
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child:  Column(
            children: [
              Container(
              color:isSelect
                  ? AppColors.primarycolor
                  : AppColors.primarycolor.withOpacity(0.8),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
                      ),
              Padding(
                padding: 1.onlyBottom,
                child: Container(height: 2,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: isSelect?AppColors.white:Colors.transparent),),
              )
            ],

      ),
    ),
  );
}
