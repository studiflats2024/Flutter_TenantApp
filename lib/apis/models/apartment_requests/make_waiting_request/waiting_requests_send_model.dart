import 'package:vivas/utils/format/app_date_format.dart';

class WaitingRequestsSendModel {
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfGuests;
  final String rentFees;
  final String city;
  final String tellMore;

  WaitingRequestsSendModel({
    required this.startDate,
    required this.endDate,
    required this.numberOfGuests,
    required this.rentFees,
    required this.city,
    required this.tellMore,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, String>> nameOfGuestsMap = [];

    return {
      "Start_Date": AppDateFormat.formattingApiDate(startDate, "en"),
      "End_Date": AppDateFormat.formattingApiDate(endDate, "en"),
      "Rent_Fees": rentFees,
      "guests": nameOfGuestsMap,
      "City": city,
      "Tell_More": tellMore,
    };
  }
}
