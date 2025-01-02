class AcceptRejectOfferSendModel {
  final String requestId;
  final bool status;
  final String? notes;

  AcceptRejectOfferSendModel({
    required this.requestId,
    required this.status,
    required this.notes,
  });

  Map<String, dynamic> toParameters() => {
        'Req_ID': requestId,
        'Status': status,
        'Notes': notes ?? "",
      };
}
