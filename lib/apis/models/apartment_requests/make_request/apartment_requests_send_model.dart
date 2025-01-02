import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/format/app_date_format.dart';

class ApartmentRequestsSendModel {
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfGuests;
  final String aptUUID;
  final String role;
  final Map<int, String> nameOfGuests;
  final String? brokerCode;
  final String purposeOfComingToGermany;

  ApartmentRequestsSendModel({
    required this.aptUUID,
    required this.startDate,
    required this.endDate,
    required this.numberOfGuests,
    required this.nameOfGuests,
    required this.role,
    required this.purposeOfComingToGermany,
    required this.brokerCode,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, String>> nameOfGuestsMap = [];
    for (var entry in nameOfGuests.entries) {
      nameOfGuestsMap.add({"guest_Name": entry.value});
    }

    return {
      "apt_UUID": aptUUID,
      "start_Date": AppDateFormat.formattingApiDate(startDate, "en"),
      "end_Date": AppDateFormat.formattingApiDate(endDate, "en"),
      "guest_No": nameOfGuests.values.toList().length,
      "role": role,
      "guests": nameOfGuestsMap,
      if (!brokerCode.isNullOrEmpty) "broker_Code": brokerCode,
      if (!purposeOfComingToGermany.isNullOrEmpty)
        "purpose_Coming": purposeOfComingToGermany,
    };
  }
}
