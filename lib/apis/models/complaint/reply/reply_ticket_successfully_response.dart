class ReplyTicketSuccessfullyResponse {
  final String status;
  final String message;

  ReplyTicketSuccessfullyResponse(
    this.status,
    this.message,
  );

  ReplyTicketSuccessfullyResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        message = json['message'] as String;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}
