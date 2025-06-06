import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/common_widget.dart';
import '../config/color.dart';
import '../controller/new_account_controller.dart';
import '../controller/new_calculation_controller.dart';
import 'calculation.dart';
import 'existing_amount.dart';
import 'extension.dart';
import 'new_account.dart';

class PublicProvidentFund extends StatelessWidget {
  PublicProvidentFund({super.key});

  final NewAccountController controller = Get.put(NewAccountController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.bgcolor,
        appBar: AppBar(
          surfaceTintColor: AppColors.primarycolor,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
          ),
          backgroundColor: AppColors.primarycolor,
          title: Text(
            "Public Provident Fund",
            style: style(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child:  Row(
                children: [
                  Obx(
                      ()=> tabBtn(
                      title: "New Account",
                      index: 0,
                      isSelect: controller.selectedIndex.value == 0,
                      onTap: () {
                        controller.changeTab(0);
                      },
                    ),
                  ),
                  Obx(
                        ()=>  tabBtn(
                      title: "Existing Account",
                      index: 1,
                      isSelect: controller.selectedIndex.value == 1,
                      onTap: () {
                        controller.changeTab(1);
                      },
                    ),
                  ),
                  Obx(
                        ()=>  tabBtn(
                      title: "Extension",
                      index: 2,
                      isSelect: controller.selectedIndex.value == 2,
                      onTap: () {
                        controller.changeTab(2);
                      },
                    ),
                  ),
                ],
              ),

          ),
        ),
        body: Obx(
              () => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              NewAccount(),
              ExistingAmount(),
              Extension(),
            ],
          ),
        ),
      ),
    );
  }
}
