import 'package:emi_calc/view/loanemi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/common_widget.dart';
import '../config/color.dart';
import '../controller/loamcompare_add_controller.dart';
import 'home.dart';
import 'loancompare_add.dart';

class LoanCompare extends StatelessWidget {
  LoanCompare({super.key});
  LoanCompareAddController controller = Get.put(LoanCompareAddController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => Home());
        return false;
      },
      child: Scaffold(backgroundColor: AppColors.bgcolor,
        appBar: commonappbar(
          text: "Loan Compare",
          icon: Icons.add,
          onPressed: () {
            Get.off(() => Home());
          },
          addOnTap: () {
            controller.updateBtn.value=false;
            controller.clear();
            Get.to(() => LoanCompareadd());
          },
        ),
        body: Obx(
              () => controller.loans.isEmpty
              ? Center(child: Text("No loans added"))
              : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: 16.symmetric,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // decoration: BoxDecoration(
                    // color: AppColors.white,borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    // Fixed first column for loan data
                    Container(

                      color: AppColors.grey.withOpacity(0.7),
                      child: Column(mainAxisSize: MainAxisSize.min,
                        children: [
                          Table(   border: TableBorder.symmetric(inside:BorderSide(color: AppColors.grey,width: 1),outside: BorderSide(color: AppColors.grey,width: 0.5),

                          ),
                            columnWidths: {
                              0: FixedColumnWidth(100.0), // Set width for the first column
                            },
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    // color: AppColors.grey.withOpacity(0.9),
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'Loan Data', color: AppColors.white),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'Amount', color: AppColors.white),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'Principal Amount', color: AppColors.white),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'ROI', color: AppColors.white),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'Tenure', color: AppColors.white),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'Total Amount', color: AppColors.white),
                                  ),
                                ],
                              ),
                           
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'Interest', color: AppColors.white),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'Extra Payment', color: AppColors.white),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: 'Pre-Payment', color: AppColors.white),
                                  ),
                                ],
                              ),  TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: loanCompareHeader(label: ' ', color: AppColors.white),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),

                    // Scrollable columns for all loans
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Generating loan data for each loan
                            ...List.generate(controller.loans.length, (index) {
                              final loan = controller.loans[index];
                              return Container(
                                color: AppColors.white,
                                child: Column(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Table(  border: TableBorder.symmetric(inside:BorderSide(color: AppColors.grey,width: 1),outside: BorderSide(color: AppColors.grey,width: 0.5),

                                    ),
                                      columnWidths: {
                                        0: FixedColumnWidth(100.0), // Set width for the first column
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Container(
                                         color: AppColors.grey.withOpacity(0.7),
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareHeader(label: 'Loan ${index + 1}', color: AppColors.white),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: loan.loanAmount, color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: loan.principleAmount.toStringAsFixed(0), color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: "${loan.annualRate} %", color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: "${loan.tenure} ${loan.isSwitchCheckedfree == false ? 'Month' : 'Year'}", color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: "${loan.totalAmount.toStringAsFixed(0)}", color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                      /*  TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: loan.loanAmount, color: AppColors.black),
                                            ),
                                          ],
                                        ),*/
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: loan.interest.toStringAsFixed(0), color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: loan.prePayAmount.isEmpty?'-':loan.prePayAmount, color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: loanCompareText(label: loan.isPrePaymentChecked ? 'Yes' : 'No', color: AppColors.black),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    child: Icon(Icons.edit, color: AppColors.black,size: 19,),
                                                    onTap: () {


                                                      controller.loanAmountController.value.text = loan.loanAmount;
                                                      controller.annualRateController.value.text = loan.annualRate;
                                                      controller.tenureController.value.text = loan.tenure;
                                                      controller.feeController.value.text = loan.fee;
                                                      controller.noteController.value.text = loan.note;
                                                      controller.isChecked.value = loan.isPrePaymentChecked;
                                                      controller.isSwitchChecked.value = loan.isSwitchChecked;
                                                      controller.isSwitchCheckedfree.value = loan.isSwitchCheckedfree;
                                                      controller.prePayAmountController.value.text=loan.prePayAmount;
                                                      controller.dropdownValueDeposit.value=loan.depositType;

                                                      String startDate = loan.startDate;
                                                      List<String> dateParts = startDate.split('/');

                                                      controller.selectedDate.value = DateTime(
                                                        int.parse(dateParts[2]),  // Year
                                                        int.parse(dateParts[0]),  // Month
                                                        int.parse(dateParts[1]),  // Day
                                                      );

                                                      controller.updateBtn.value=true;
                                                      controller.index=index;
                                                      Get.to(() => LoanCompareadd());
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: Icon(Icons.delete, color: Colors.red,size: 19,),
                                                    onTap: () {

                                                      deleteDialog(confirmOnPressed: () {
                                                        controller.loans.removeAt(index);
                                                        controller.saveLoansToStorage();
                                                        Get.back();
                                                      },);

                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget loanCompareHeader({required color, required label}) {
  return Text(label, maxLines: 1,overflow: TextOverflow.ellipsis,style: style(color: color, fontSize: 13,fontWeight: FontWeight.w700));
}Widget loanCompareText({required color, required label}) {
  return Text(label,maxLines: 1,overflow: TextOverflow.ellipsis, style: style(color: color, fontSize: 13,fontWeight: FontWeight.w400));
}
