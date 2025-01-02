class StartChatSuccessfullyResponse {
  final String status;
  final String message;
  final String chatUUID;

  StartChatSuccessfullyResponse(
    this.status,
    this.message,
    this.chatUUID,
  );

  StartChatSuccessfullyResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        chatUUID = json['uuid'] as String,
        message = json['message'] as String;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}
