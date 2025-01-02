class UpdateEmailOrPhoneResponse {
  String? message;
  String? status;
  bool? confirmedMail;
  String? uuid;

  UpdateEmailOrPhoneResponse(
      {this.message, this.status, this.confirmedMail, this.uuid});

  UpdateEmailOrPhoneResponse.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    confirmedMail = json['confirmed_Mail'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['confirmed_Mail'] = confirmedMail;
    map['uuid'] = uuid;
    return map;
  }
}
