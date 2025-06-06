class Loan {
  final String loanAmount;
  final String annualRate;
  final String tenure;
  final String fee;
  final String note;
  final bool isPrePaymentChecked;
  final bool isSwitchChecked;
  final bool isSwitchCheckedfree;
  final String startDate;
  final double interest;
  final double totalAmount;
  final double principleAmount;
  final String prePayAmount; // Added pre-payment amount
  final String depositType;
  final String emiAmount;
  final String  feesCharges;
  final String extraPay;

  Loan({
    required this.loanAmount,
    required this.annualRate,
    required this.tenure,
    required this.fee,
    required this.note,
    required this.isPrePaymentChecked,
    required this.isSwitchChecked,
    required this.isSwitchCheckedfree,
    required this.startDate,
    required this.interest,
    required this.principleAmount,
    required this.totalAmount,
    required this.prePayAmount, // New constructor parameter
    required this.depositType,
    required this.feesCharges,
     this.emiAmount='0.0',
    required this.extraPay,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      loanAmount: json['loanAmount'],
      annualRate: json['annualRate'],
      tenure: json['tenure'],
      fee: json['fee'],
      note: json['note'],
      isPrePaymentChecked: json['isPrePaymentChecked'],
      isSwitchChecked: json['isSwitchChecked'],
      isSwitchCheckedfree: json['isSwitchCheckedfree'],
      startDate: json['startDate'],
      interest: json['interest'],
      totalAmount: json['totalAmount'],
      principleAmount: json['principleAmount'],
      prePayAmount: json['prePayAmount'] ?? 0.0,
      depositType: json['depositType'],
      feesCharges: json['feesCharges'],
      emiAmount: json['emiAmount'],
      extraPay: json['extraPay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanAmount': loanAmount,
      'annualRate': annualRate,
      'tenure': tenure,
      'fee': fee,
      'note': note,
      'isPrePaymentChecked': isPrePaymentChecked,
      'isSwitchChecked': isSwitchChecked,
      'isSwitchCheckedfree': isSwitchCheckedfree,
      'startDate': startDate,
      'interest': interest,
      'totalAmount': totalAmount,
      'principleAmount': principleAmount,
      'prePayAmount': prePayAmount, // Include prePayAmount in the toJson map
      'depositType': depositType,
      'feesCharges': feesCharges,
      'emiAmount': emiAmount,
      'extraPay': extraPay,
    };
  }
}
