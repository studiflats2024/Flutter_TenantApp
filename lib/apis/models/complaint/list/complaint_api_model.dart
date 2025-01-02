import 'package:vivas/utils/format/app_date_format.dart';

class ComplaintApiModel {
  final String ticketID;
  final String ticketCode;
  final DateTime createdAt;
  final String ticketType;
  final String ticketDesc;
  final String status;
  final DateTime? closedAt;

  ComplaintApiModel({
    required this.ticketID,
    required this.ticketCode,
    required this.createdAt,
    required this.ticketType,
    required this.ticketDesc,
    required this.status,
    required this.closedAt,
  });

  factory ComplaintApiModel.fromJson(Map<String, dynamic> json) =>
      ComplaintApiModel(
        ticketID: json['ticket_ID'] as String,
        ticketCode: json['ticket_Code'] as String,
        createdAt:
            AppDateFormat.appDateFormApiParse(json['created_At'] as String),
        ticketType: json['ticket_Type'] as String,
        ticketDesc: json['ticket_Desc'] as String,
        status: json['status'] as String,
        closedAt: json['closed_At'] != null
            ? AppDateFormat.appDateFormApiParse(json['closed_At'] as String)
            : null,
      );
}
