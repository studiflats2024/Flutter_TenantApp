import 'package:vivas/apis/models/apartment_requests/apartment_requests/guests_request_model.dart';

class UpdateGuestsRequestSendModel {
  final String requestId;
  final List<GuestsRequestModel> guestList;

  UpdateGuestsRequestSendModel({
    required this.requestId,
    required this.guestList,
  });

  List<Map<String, String>> toMap() {
    List<Map<String, String>> guestListMap = [];
    for (var entry in guestList) {
      guestListMap.add(entry.toJson());
    }

    return guestListMap;
  }

  Map<String, dynamic> toParameters() => {
        'Req_ID': requestId,
      };
}
