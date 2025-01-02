import 'package:vivas/utils/format/app_date_format.dart';

class InvoiceApiModel {
  final String invId;
  final String invCode;
  final String aptName;
  final String aptAddress;
  final bool invPaid;
  final DateTime invIssue;
  final DateTime invStartDate;
  final DateTime invEndDate;
  final num invSecDeposit;
  final num invServiceFee;
  final num invTotal;
  final String invType;
  final String downloadUrl;
  final bool canPayOnline;
  final bool canPayCash;
  final bool isMonthly;

  InvoiceApiModel({
    required this.invId,
    required this.invIssue,
    required this.invCode,
    required this.invStartDate,
    required this.invEndDate,
    required this.invSecDeposit,
    required this.invServiceFee,
    required this.invTotal,
    required this.invPaid,
    required this.invType,
    required this.aptName,
    required this.aptAddress,
    required this.canPayOnline,
    required this.canPayCash,
    required this.downloadUrl,
    required this.isMonthly,
  });

  factory InvoiceApiModel.fromJson(Map<String, dynamic> json) =>
      InvoiceApiModel(
        invId: json['inv_ID'] as String,
        invCode: json['inv_Code'] as String,
        invIssue:
            AppDateFormat.appDateFormApiParse(json['inv_Issue'] as String),
        invStartDate: json['inv_StartDate'] == null
            ? DateTime(0)
            : AppDateFormat.appDateFormApiParse(
                json['inv_StartDate'] as String),
        invEndDate: json['inv_EndDate'] == null
            ? DateTime(0)
            : AppDateFormat.appDateFormApiParse(json['inv_EndDate'] as String),
        invSecDeposit: json['inv_SecDeposit'] as num? ?? 0,
        invServiceFee: json['inv_ServiceFee'] as num? ?? 0,
        invTotal: json['inv_Total'] as num? ?? 0,
        invPaid: json['inv_Paid'] as bool,
        invType: json['payment_Method'] as String? ?? "",
        aptName: json['apt_Name'] as String? ?? "",
        aptAddress: json['apt_Address'] as String? ?? "",
        downloadUrl: json['file_Path'] as String? ?? "",
        canPayOnline: json['online'] as bool? ?? true,
        canPayCash: json['cash'] as bool? ?? true,
        isMonthly: json['is_Monthly'] as bool? ?? false,
      );
}
