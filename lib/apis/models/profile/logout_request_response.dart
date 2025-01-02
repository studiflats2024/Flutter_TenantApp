class LogoutResponse {
  final String message;

  LogoutResponse(this.message);

  LogoutResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
