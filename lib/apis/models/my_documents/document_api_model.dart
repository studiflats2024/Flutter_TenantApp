import 'package:vivas/utils/format/app_date_format.dart';

class DocumentApiModel {
  final String? reqId;
  final String? reqAptID;
  final DateTime invStartDate;
  final DateTime invEndDate;
  final num? rentPrice;
  final String? downloadUrl;
  final String? aptName;

  DocumentApiModel({
    required this.reqId,
    required this.reqAptID,
    required this.invStartDate,
    required this.invEndDate,
    required this.rentPrice,
    required this.downloadUrl,
    required this.aptName,
  });

  factory DocumentApiModel.fromJson(Map<String, dynamic> json) =>
      DocumentApiModel(
        reqId: json['req_ID'] as String,
        reqAptID: json['req_Apt_ID'] as String,
        invStartDate:
            AppDateFormat.appDateFormApiParse(json['check_IN'] as String),
        invEndDate:
            AppDateFormat.appDateFormApiParse(json['check_Out'] as String),
        rentPrice: json['rent_Price'] as num,
        downloadUrl: json['file_Path'] as String? ?? "",
        aptName: json['apt_Name'] as String? ?? "",
      );
}
