class GetCheckoutSendModel {
  final String requestId;

  GetCheckoutSendModel({required this.requestId});

  Map<String, dynamic> toMap() {
    return {
      "Req_ID": requestId,
    };
  }
}
