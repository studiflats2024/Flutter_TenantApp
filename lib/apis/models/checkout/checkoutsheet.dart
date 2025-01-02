// ignore_for_file: unnecessary_this

import 'package:vivas/apis/models/checkout/expense_checkouts.dart';
import 'package:vivas/apis/models/checkout/issue_checkouts.dart';

class CheckoutSheet {
  String? reqID;
  double? paidSecuirty;
  List<IssueCheckouts>? issueCheckouts;
  List<ExpenseCheckouts>? expenseCheckouts;
  double? refundedDeposit;
  bool? isCashDeposit;
  String? monthInvID;
  DateTime? invDate;
  double? invTotal = 0;
  CheckoutSheet(
      {this.reqID,
      this.paidSecuirty,
      this.issueCheckouts,
      this.expenseCheckouts,
      this.refundedDeposit,
      this.isCashDeposit});

  CheckoutSheet.fromJson(Map<String, dynamic> json) {
    reqID = json["req_ID"] as String?;
    paidSecuirty = json['paid_Secuirty'].toDouble();
    monthInvID = json['monthInvID'] as String?;
    invDate = DateTime.tryParse(json['invDate']) as DateTime;
    invTotal = (json['invTotal'] as double?)!.toDouble();

    if (json['issue_Checkouts'] != null) {
      issueCheckouts = <IssueCheckouts>[];
      json['issue_Checkouts'].forEach((v) {
        // ignore: unnecessary_new
        issueCheckouts!.add(new IssueCheckouts.fromJson(v));
      });
    }
    if (json['expense_Checkouts'] != null) {
      expenseCheckouts = <ExpenseCheckouts>[];
      json['expense_Checkouts'].forEach((v) {
        // ignore: unnecessary_new
        expenseCheckouts!.add(new ExpenseCheckouts.fromJson(v));
      });
    }
    refundedDeposit = json['refunded_Deposit'].toDouble();
    isCashDeposit = json['is_Cash_Deposit'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['req_ID'] = this.reqID;
    data['monthInvID'] = this.monthInvID;
    data['invDate'] = this.invDate;
    data['invTotal'] = this.invDate;

    data['paid_Secuirty'] = this.paidSecuirty;
    data['is_Cash_Deposit'] = this.isCashDeposit;

    if (this.issueCheckouts != null) {
      data['issue_Checkouts'] =
          this.issueCheckouts!.map((v) => v.toJson()).toList();
    }
    if (this.expenseCheckouts != null) {
      data['expense_Checkouts'] =
          this.expenseCheckouts!.map((v) => v.toJson()).toList();
    }
    data['refunded_Deposit'] = this.refundedDeposit;
    return data;
  }
}
