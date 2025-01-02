class ResetPasswordSendModelApi {
  final String uuid;
  final String password;
  final String token;

  ResetPasswordSendModelApi(this.uuid, this.token, this.password);

  Map<String, dynamic> toMap() {
    return {
      "UUID": uuid,
      "Password": password,
      "Confirm_Password": password,
      "Token": token,
    };
  }

  Map<String, dynamic> toMapV2() {
    return {
      "Password": password,
    };
  }
}
