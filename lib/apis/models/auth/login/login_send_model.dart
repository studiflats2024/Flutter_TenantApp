class LoginSendModelApi {
  final String username;
  final String password;
  final String deviceToken;

  LoginSendModelApi(this.username, this.password, this.deviceToken);

  Map<String, dynamic> toMap() {
    return {
      "mobile": username,
      "password": password,
      "deviceToken": deviceToken,
    };
  }
}
