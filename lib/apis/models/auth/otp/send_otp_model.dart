class SendOtpModelApi {
  final String uuid;

  SendOtpModelApi(this.uuid);

  Map<String, dynamic> toMap() {
    return {
      "UUID": uuid,
    };
  }
}
