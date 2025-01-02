import 'dart:convert';

HandoverProtocolsResponseModel handoverProtocolsResponseModelFromJson(String str) => HandoverProtocolsResponseModel.fromJson(json.decode(str));

String handoverProtocolsResponseModelToJson(HandoverProtocolsResponseModel data) => json.encode(data.toJson());

class HandoverProtocolsResponseModel {
  String? handoverId;
  Map? handoverItems;

  HandoverProtocolsResponseModel({
    this.handoverId,
    this.handoverItems,
  });

  factory HandoverProtocolsResponseModel.fromJson(Map<String, dynamic> json) => HandoverProtocolsResponseModel(
    handoverId: json["handover_ID"],
    handoverItems: json["handover_Items"],
  );

  Map<String, dynamic> toJson() => {
    "handover_ID": handoverId,
    "handover_Items": handoverItems??{},
  };
}