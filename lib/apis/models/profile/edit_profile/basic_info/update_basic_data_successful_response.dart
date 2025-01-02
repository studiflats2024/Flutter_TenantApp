class UpdateBasicDataSuccessfulResponse {
  UpdateBasicDataSuccessfulResponse({
    this.message,
    this.status,
  });

  UpdateBasicDataSuccessfulResponse.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
  }
  String? message;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    return map;
  }
}
