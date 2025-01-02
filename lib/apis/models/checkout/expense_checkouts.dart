// ignore_for_file: unnecessary_this

class ExpenseCheckouts {
  String? expenseType;
  double? expenseAmount;
  String? expenseDesc;
  String? expenseFile;
  String? expenseDate;

  ExpenseCheckouts(
      {this.expenseType,
      this.expenseAmount,
      this.expenseDesc,
      this.expenseFile,
      this.expenseDate});

  ExpenseCheckouts.fromJson(Map<String, dynamic> json) {
    expenseType = json['expense_Type'];
    expenseAmount = json['expense_Amount'].toDouble();
    expenseDesc = json['expense_Desc'];
    expenseFile = json['expense_File'];
    expenseDate = json['expense_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expense_Type'] = this.expenseType;
    data['expense_Amount'] = this.expenseAmount;
    data['expense_Desc'] = this.expenseDesc;
    data['expense_File'] = this.expenseFile;
    data['expense_Date'] = this.expenseDate;
    return data;
  }
}
