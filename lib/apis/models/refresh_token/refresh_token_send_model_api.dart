class RefreshTokenSendModelApi {
  final String refreshToken;
  final String accessToken;

  RefreshTokenSendModelApi(this.refreshToken, this.accessToken);

  Map<String, dynamic> toMap() {
    return {
      "refresh_token": refreshToken,
      "accessToken": accessToken,
    };
  }
}
