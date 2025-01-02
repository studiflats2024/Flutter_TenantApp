class CancelRequestSendModel {
  final String requestId;
  final String reason;
  final String guestId;
  final DateTime? terminationDate;

  CancelRequestSendModel({
    required this.requestId,
    required this.reason,
    required this.guestId,
    required this.terminationDate,
  });

  Map<String, dynamic> toParameters() => {
        'Req_ID': requestId,
        "Reason": reason,
    "Guest_ID": guestId,
        if (terminationDate != null) "Date": terminationDate,
      };
}
