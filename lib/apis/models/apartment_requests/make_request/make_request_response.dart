class MakeRequestResponse {
  final String requestId;
  final String requestCode;
  final String message;

  MakeRequestResponse(
    this.message,
    this.requestId,
    this.requestCode,
  );

  MakeRequestResponse.fromJson(Map<String, dynamic> json)
      : requestId = json['request_ID'] as String,
        requestCode = json['request_Code'] as String,
        message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'message': message,
      };
}class MakeRequestResponseV2 {
  final String? requestId;
  final String requestCode;
  final String message;

  MakeRequestResponseV2(
    this.message,
    this.requestId,
    this.requestCode,
  );

  MakeRequestResponseV2.fromJson(Map<String, dynamic> json)
      : requestId = json['uuid'] ,
        requestCode = json['status'] as String,
        message = json['message'] as String;

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'message': message,
      };
}
