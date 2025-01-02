class SignContractSuccessfullyResponse {
  final String status;
  final String message;

  SignContractSuccessfullyResponse(
    this.status,
    this.message,
  );

  SignContractSuccessfullyResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] ??"",
        message = json['message'] ??"";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}
