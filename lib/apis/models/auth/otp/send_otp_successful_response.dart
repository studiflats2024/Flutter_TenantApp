class SendOtpSuccessfulResponse {
  final String status;
  final String message;
  final String uuid;

  SendOtpSuccessfulResponse(
    this.status,
    this.message,
    this.uuid,
  );
  static SendOtpSuccessfulResponse demo =
      SendOtpSuccessfulResponse("status", "message", "uuid");

  SendOtpSuccessfulResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        message = json['message'] as String,
        uuid = json['uuid'];

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'uuid': uuid,
      };
}
