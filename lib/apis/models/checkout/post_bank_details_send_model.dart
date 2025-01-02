class PostBankDetailsSendModel {
  final String requestId;
  final String accountName;
  final String accountNo;
  final String accountIban;
  final String accountSwift;

  PostBankDetailsSendModel(
      {required this.requestId,
      required this.accountName,
      required this.accountNo,
      required this.accountIban,
      required this.accountSwift});

  Map<String, dynamic> toMap() {
    return {
      "req_ID": requestId,
      "account_Name": accountName,
      "account_No": accountNo,
      "account_Iban": accountIban,
      "account_Swift": accountSwift,
    };
  }
}
