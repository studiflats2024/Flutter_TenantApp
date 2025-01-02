class CheckOtpModelApi {
  final String otpCode;
  final String uuid;

  CheckOtpModelApi(this.otpCode, this.uuid);

  Map<String, dynamic> toMap() {
    return {
      "Otp": otpCode,
      "UUID": uuid,
    };
  }
}
