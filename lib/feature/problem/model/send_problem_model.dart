import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class SendProblemModel extends Equatable {
  final String aptUUID;
  String? nameRingBell;
  String? phoneNumber;
  String? phoneNumber2;
  String? issueDesc;
  List<String> imagesUrl = [];
  Map<int, Map<String, String>> dateTimeAvailable = {};

  SendProblemModel({
    required this.aptUUID,
  });

  @override
  List<Object?> get props => [
        nameRingBell,
        phoneNumber,
        phoneNumber2,
        dateTimeAvailable,
        issueDesc,
        imagesUrl,
      ];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'apt_ID': aptUUID,
      'name_RingBell': nameRingBell,
      'phone_Number': phoneNumber,
      'phone_Number2': phoneNumber2,
      'issue_Desc': issueDesc,
    };

    map.putIfAbsent(
        "issue_Images", () => imagesUrl.map((e) => {"img_Url": e}).toList());

    map.putIfAbsent(
        "issue_Appt",
        () => dateTimeAvailable.values
            .map((e) => {
                  "appo_Time": e["time"],
                  "appo_Date": e["date"],
                })
            .toList());

    return map;
  }
}

class DateTimeAvailable {
  final String date;
  final String time;

  DateTimeAvailable(this.date, this.time);
}
