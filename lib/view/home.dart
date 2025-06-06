import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/home_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/config/list.dart';
import 'package:emi_calc/view/cash_counter.dart';
import 'package:emi_calc/view/age_cal.dart';
import 'package:emi_calc/view/amount_toword.dart';
import 'package:emi_calc/view/compound_int.dart';
import 'package:emi_calc/view/fixed_deposite.dart';
import 'package:emi_calc/view/goal_cal.dart';
import 'package:emi_calc/view/gst_cal.dart';
import 'package:emi_calc/view/homeloan.dart';
import 'package:emi_calc/view/kishan_vikas.dart';
import 'package:emi_calc/view/loancompare.dart';
import 'package:emi_calc/view/loanemi.dart';
import 'package:emi_calc/view/lumpsum_cal.dart';
import 'package:emi_calc/view/national_saving.dart';
import 'package:emi_calc/view/pm_jeevan.dart';
import 'package:emi_calc/view/pm_suraksha.dart';
import 'package:emi_calc/view/public_providentfund.dart';
import 'package:emi_calc/view/rd_cal.dart';
import 'package:emi_calc/view/senior_citizen.dart';
import 'package:emi_calc/view/sip_cal.dart';
import 'package:emi_calc/view/sukanya.dart';
import 'package:emi_calc/view/swp_cal.dart';
import 'package:emi_calc/view/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    String appLink = "https://play.google.com/store/games?device=windows";
    String policyLink = "https://play.google.com/store/games?device=windows";
    return WillPopScope(onWillPop: () async {
      await appExitDialog(context,
      title: 'Exit App.',
      content: 'Are you sure you want to exit the app?',
      cancelOnTap: () {
        Get.back();
      }, confirmOnTap: () {
        SystemNavigator.pop();
      });
      return false;
    },
      child: Scaffold(
        backgroundColor: AppColors.bgcolor,
        appBar: AppBar(
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: AppColors.white,
              ),
            ),
          ),
          backgroundColor: AppColors.primarycolor,
          title: Text(
            "Home",
            style: style(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 17),
          ),
        ),
        drawer: Drawer(
          backgroundColor: AppColors.primarycolor,
          child: ListView(
            padding: 50.onlyTop,
            children: [
              homeDrawer(),
              20.height,
              Padding(
                padding: 10.onlyLeft,
                child: drawerListTile(
                  text: "Remove Ads",
                  icon: Icons.home,
                ),
              ),
              Padding(
                padding: 10.onlyLeft,
                child: drawerListTile(onTap: () {

                },
                  text: "About Us",
                  icon: Icons.no_backpack_outlined,
                ),
              ),
              Padding(
                padding: 10.onlyLeft,
                child: drawerListTile(onTap: () async {
                  if (await canLaunch(appLink)) {
                  await launch(appLink);
                  } else {
                  throw 'Could not launch $appLink';
                  }
                },
                  text: "Rate Us",
                  icon: Icons.star_rate_outlined,
                ),
              ),
              Padding(
                padding: 10.onlyLeft,
                child: drawerListTile(onTap: () async {

                  Share.share("$appLink");
                },
                  text: "share",
                  icon: Icons.share,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: 10.horizontal,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,
                labeltext(text: "EMI Calculator"),
                10.height,
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 100,
                        crossAxisCount: 3),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: emicalculatorlist.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          if (emicalculatorlist[i]['label'] == 'Loan EMI') {
                            Get.to(() => LoanEmi());
                          } else if (emicalculatorlist[i]['label'] ==
                              'Loan Compare') {
                            Get.to(() => LoanCompare());
                          } else if (emicalculatorlist[i]['label'] ==
                              'Vehicle Loan') {
                            Get.to(() => Vehicle());
                          } else if (emicalculatorlist[i]['label'] ==
                              'Home Loan\nInterest Rates') {
                            Get.to(() => HomeLoan());
                          }
                        },
                        child: EmicalContainer(
                          img: emicalculatorlist[i]['image'],
                          label: emicalculatorlist[i]['label'],
                        ),
                      );
                    }),
                10.height,
                labeltext(text: "Mutual Fund Calculator"),
                10.height,
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 100,
                        crossAxisCount: 3),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Mutualfundlist.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          if (Mutualfundlist[i]['label'] == 'SIP Calculator') {
                            Get.to(() => SipCal());
                          } else if (Mutualfundlist[i]['label'] ==
                              'SWP Calculator') {
                            Get.to(() => SwpCal());
                          } else if (Mutualfundlist[i]['label'] ==
                              'LumpSum \nCalculator') {
                            Get.to(() => LumpSumCal());
                          } else if (Mutualfundlist[i]['label'] ==
                              'Goal Calculator') {
                            Get.to(() => GoalCal());
                          }
                        },
                        child: EmicalContainer(
                          img: Mutualfundlist[i]['image'],
                          label: Mutualfundlist[i]['label'],
                        ),
                      );
                    }),
                10.height,
                labeltext(text: "Bank Calculator"),
                10.height,
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 100,
                        crossAxisCount: 3),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bankList.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          if (bankList[i]['label'] == 'Fixed Deposit') {
                            Get.to(() => FixedDeposite());
                          } else if (bankList[i]['label'] == 'RD Calculator') {
                            Get.to(() => RdCal());
                          }
                        },
                        child: EmicalContainer(
                          img: bankList[i]['image'],
                          label: bankList[i]['label'],
                        ),
                      );
                    }),
                10.height,
                labeltext(text: "Useful Tools"),
                10.height,
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 100,
                        crossAxisCount: 3),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userFulToolsList.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          if (userFulToolsList[i]['label'] == 'GST Calculator') {
                            Get.to(() => GstCal());
                          } else if (userFulToolsList[i]['label'] ==
                              'Age Calculator') {
                            Get.to(() => AgeCal());
                          } else if (userFulToolsList[i]['label'] ==
                              'Cash Counter') {
                            Get.to(
                              () => CashCounter(),
                            );
                          } else if (userFulToolsList[i]['label'] ==
                              'Compound \nInterest') {
                            Get.to(() => CompoundInt());
                          } else if (userFulToolsList[i]['label'] ==
                              'Amount To Word') {
                            Get.to(() => AmountToword());
                          }
                        },
                        child: EmicalContainer(
                          img: userFulToolsList[i]['image'],
                          label: userFulToolsList[i]['label'],
                        ),
                      );
                    }),
                10.height,
                labeltext(text: "Post Office Calculator"),
                10.height,
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 100,
                        crossAxisCount: 3),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: postOfficeList.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          if (postOfficeList[i]['label'] ==
                              'Public Provident \nFund') {
                            Get.to(
                              () => PublicProvidentFund(),
                            );
                          } else if (postOfficeList[i]['label'] ==
                              'Senior Citizen \nSaving Scheme') {
                            Get.to(() => SeniorCitizen());
                          } else if (postOfficeList[i]['label'] ==
                              'Sukanya \nSamriddhi') {
                            Get.to(
                              () => Sukanya(),
                            );
                          } else if (postOfficeList[i]['label'] ==
                              'Kishan Vikas \nPatra') {
                            Get.to(() => KishanVikas());
                          } else if (postOfficeList[i]['label'] ==
                              'National Saving \nCertificate') {
                            Get.to(() => NationalSaving());
                          }
                        },
                        child: EmicalContainer(
                          img: postOfficeList[i]['image'],
                          label: postOfficeList[i]['label'],
                        ),
                      );
                    }),
                10.height,
                labeltext(text: "Insurance Calculator"),
                10.height,
                GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 100,
                        crossAxisCount: 3),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: insuranceList.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          if (insuranceList[i]['label'] ==
                              'PM Jeevan Jyoti \nBima(Life)') {
                            Get.to(() => PmJeevan());
                          } else if (insuranceList[i]['label'] ==
                              'PM Suraksha \nBima(Life)') {
                            Get.to(() => PmSurksha());
                          }
                        },
                        child: EmicalContainer(
                          img: insuranceList[i]['image'],
                          label: insuranceList[i]['label'],
                        ),
                      );
                    }),
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
