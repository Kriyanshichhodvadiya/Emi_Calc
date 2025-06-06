import 'package:emi_calc/common/common_widget.dart';
import 'package:emi_calc/common/home_loan_common.dart';
import 'package:emi_calc/config/color.dart';
import 'package:flutter/material.dart';

import '../config/list.dart';

class HomeLoan extends StatelessWidget {
  const HomeLoan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonappbar(text: "Home Loan Interest Rates"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                border: TableBorder.all(
                  color: Colors.black,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(3),
                },
                children: [
                  // Table header
                  TableRow(
                    decoration: BoxDecoration(color: AppColors.primarycolor),
                    children: [
                      HeaderText(label: "Name of Lender"),
                      HeaderText(label: "Up to RS. 30 Lakh"),
                      HeaderText(
                          label: "Above Rs. 30 Lakh & Up to Rs. 75 Lakh"),
                      HeaderText(label: "Above Rs. 75 Lakh"),
                    ],
                  ),
                  // Example data rows
                  ...loanData.map((loan) {
                    return TableRow(
                      children: [
                        RowData(text: loan["name"]!),
                        RowData(text: loan["upTo30Lakh"]!),
                        RowData(text: loan["above30To75Lakh"]!),
                        RowData(text: loan["above75Lakh"]!),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


