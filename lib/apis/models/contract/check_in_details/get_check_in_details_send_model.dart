class GetCheckInDetailsSendModel {
  final String requestId;

  GetCheckInDetailsSendModel({required this.requestId});

  Map<String, dynamic> toMap() {
    return {
      "Req_ID": requestId,
    };
  }
}
