class PostBankDetailsSuccessfullyResponse {
  final String status;
  final String message;

  PostBankDetailsSuccessfullyResponse(
    this.status,
    this.message,
  );

  PostBankDetailsSuccessfullyResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        message = json['message'] as String;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}
