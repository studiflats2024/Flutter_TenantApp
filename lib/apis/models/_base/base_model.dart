import 'dart:convert';

BaseMessageModel baseMessageModelFromJson(String str) => BaseMessageModel.fromJson(json.decode(str));

String baseMessageModelToJson(BaseMessageModel data) => json.encode(data.toJson());

class BaseMessageModel {
  String? status;
  String? message;

  BaseMessageModel({
    this.status,
    this.message,
  });

  factory BaseMessageModel.fromJson(Map<String, dynamic> json) => BaseMessageModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
