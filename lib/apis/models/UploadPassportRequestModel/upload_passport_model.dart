import 'package:vivas/apis/models/UploadPassportRequestModel/passport_request_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/guests_request_model.dart';

class UploadRequestModel {
  final String requestId;
  final List<PassportRequestModel> guestList;

  UploadRequestModel({
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
    'Request_ID': requestId,
  };
}
