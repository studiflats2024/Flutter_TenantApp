import 'package:vivas/utils/format/app_date_format.dart';

class UpdateRequestDateSendModel {
  final String requestId;
  final DateTime startDate;
  final DateTime endDate;

  UpdateRequestDateSendModel({
    required this.requestId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toParameters() => {
        'Req_ID': requestId,
        'Start_Date': AppDateFormat.formattingApiDate(startDate, "en"),
        'End_Date': AppDateFormat.formattingApiDate(endDate, "en"),
      };
}
