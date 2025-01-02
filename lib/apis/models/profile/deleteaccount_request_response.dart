class DeleteAccountResponse {
  final String message;

  DeleteAccountResponse(this.message);

  DeleteAccountResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
