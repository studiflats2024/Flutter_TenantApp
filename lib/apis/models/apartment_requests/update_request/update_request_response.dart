class UpdateRequestResponse {
  final String message;

  UpdateRequestResponse(this.message);

  UpdateRequestResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
