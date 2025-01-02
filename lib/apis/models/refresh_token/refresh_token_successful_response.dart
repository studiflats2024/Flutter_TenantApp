class RefreshTokenSuccessfulResponse {
  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String? refreshToken;

  RefreshTokenSuccessfulResponse(
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
  );

  RefreshTokenSuccessfulResponse.fromJson(Map<String, dynamic> json)
      : expiresIn = json['expires_in'] as int,
        tokenType = json['token_type'] as String,
        accessToken = json['access_token'] as String,
        refreshToken = json['refresh_token'];

  Map<String, dynamic> toJson() => {
        'expires_in': expiresIn,
        'token_type': tokenType,
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}
