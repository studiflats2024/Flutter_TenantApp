class UpdateGuestsRequestResponse {
  final DateTime updatedExpiredDate;
  final String message;

  UpdateGuestsRequestResponse(
    this.message,
    this.updatedExpiredDate,
  );

  UpdateGuestsRequestResponse.fromJson(Map<String, dynamic> json)
      : updatedExpiredDate = DateTime.parse(json['expire'] as String),
        message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'expire': updatedExpiredDate.toString(),
        'message': message,
      };
}
