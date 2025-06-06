import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/view/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      Get.offAll(()=>Home());
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // bool? openFirst = prefs.getBool('openFirst') ?? false;
      //
      // if (openFirst) {
      //
      //   Get.offAndToNamed('/home');
      //
      // } else {
      //   Get.offAndToNamed('/onboarding');
      // }
    });
    return Scaffold(
      backgroundColor: AppColors.primarycolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                  ),
                ),
                30.height,
                Text(
                  "EMI Calculator",
                  style: style(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white),
                ),
                Text(
                  "Loan Planner",
                  style: style(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
