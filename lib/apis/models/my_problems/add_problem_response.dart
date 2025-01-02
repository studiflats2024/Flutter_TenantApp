class AddProblemResponse {
  final String uuid;
  final String status;
  final String message;

  AddProblemResponse(
    this.message,
    this.uuid,
    this.status,
  );

  AddProblemResponse.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'] as String? ?? "",
        status = json['status'] as String,
        message = json['message'] as String;
}
