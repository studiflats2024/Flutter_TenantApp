class WaitingRequestResponse {
  final String message;

  WaitingRequestResponse(
    this.message,
  );

  WaitingRequestResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
