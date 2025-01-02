class ForgetPasswordSuccessfulResponse {
  final String status;
  final String message;
  final String uuid;
  final String resetToken;

  ForgetPasswordSuccessfulResponse(
    this.status,
    this.message,
    this.uuid,
    this.resetToken,
  );

  ForgetPasswordSuccessfulResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        message = json['message'] as String,
        resetToken = json['reset_Token'] as String,
        uuid = json['uuid'];

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'uuid': uuid,
        'reset_Token': resetToken,
      };
}
