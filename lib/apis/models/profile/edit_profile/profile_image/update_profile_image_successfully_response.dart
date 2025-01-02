class UpdateProfileImageSuccessfullyResponse {
  String? status;
  String? message;
  String? url;

  UpdateProfileImageSuccessfullyResponse({
    this.status,
    this.message,
    this.url,
  });

  UpdateProfileImageSuccessfullyResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['url'] = url;
    return map;
  }
}
