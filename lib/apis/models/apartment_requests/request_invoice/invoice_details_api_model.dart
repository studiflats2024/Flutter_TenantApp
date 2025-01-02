class InvoiceDetailsApiModel {
  final String invId;
  final String reqId;
  final String invCode;
  final DateTime invIssue;
  final DateTime invStartDate;
  final DateTime invEndDate;
  final num invSecDeposit;
  final num invServiceFee;
  final num invTotal;
  final bool invPaid;
  final String invType;
  final String aptName;
  final String aptAddress;

  InvoiceDetailsApiModel({
    required this.invId,
    required this.reqId,
    required this.invCode,
    required this.invIssue,
    required this.invStartDate,
    required this.invEndDate,
    required this.invSecDeposit,
    required this.invServiceFee,
    required this.invTotal,
    required this.invPaid,
    required this.invType,
    required this.aptName,
    required this.aptAddress,
  });

  factory InvoiceDetailsApiModel.fromJson(Map<String, dynamic> json) =>
      InvoiceDetailsApiModel(
        invId: json["createds_inv"][0]['inv_ID'] as String,
        reqId: json["createds_inv"][0]['req_ID'] as String,
        invCode: json["createds_inv"][0]['inv_Code'] as String,
        invIssue:
            DateTime.parse(json["createds_inv"][0]['inv_Issue'] as String),
        invStartDate:
            DateTime.parse(json["createds_inv"][0]['inv_StartDate'] as String),
        invEndDate:
            DateTime.parse(json["createds_inv"][0]['inv_EndDate'] as String),
        invSecDeposit: json["createds_inv"][0]['inv_SecDeposit'] as num,
        invServiceFee: json["createds_inv"][0]['inv_ServiceFee'] as num,
        invTotal: json["createds_inv"][0]['inv_Total'] as num,
        invPaid: json["createds_inv"][0]['inv_Paid'] as bool,
        invType: "",
        aptName: json["createds_inv"][0]['apt_Name'] as String? ?? "",
        aptAddress: json["createds_inv"][0]['apt_Address'] as String? ?? "",
      );

  Map<String, dynamic> toJson() => {
        'inv_ID': invId,
        'req_ID': reqId,
        'inv_Code': invCode,
        'inv_Issue': invIssue.toIso8601String(),
        'inv_StartDate': invStartDate,
        'inv_EndDate': invEndDate,
        'inv_SecDeposit': invSecDeposit,
        'inv_ServiceFee': invServiceFee,
        'inv_Total': invTotal,
        'inv_Paid': invPaid,
        'inv_Type': invType,
      };

  static List<InvoiceDetailsApiModel> get demo {
    return List.generate(
        10,
        (index) => InvoiceDetailsApiModel(
              invId: '$index',
              aptName: 'The Aston Vill Hotel',
              invTotal: (index + 1) * 155,
              invIssue: DateTime.now(),
              reqId: '123',
              invCode: '321',
              invStartDate: DateTime.now(),
              invEndDate: DateTime.now(),
              invSecDeposit: 250,
              invServiceFee: 500,
              invPaid: (index % 2 == 0),
              invType: 'Cash',
              aptAddress: 'Alice Springs NT 0870',
            ));
  }
}
