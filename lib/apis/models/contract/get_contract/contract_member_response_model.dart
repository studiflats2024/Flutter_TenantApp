import 'dart:convert';

List<ContractMemberResponseModel> contractMemberResponseModelFromJson(String str) => List<ContractMemberResponseModel>.from(json.decode(str).map((x) => ContractMemberResponseModel.fromJson(x)));

String contractMemberResponseModelToJson(List<ContractMemberResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ContractMemberResponseModel {
  String? clauseName;
  String? clauseDetails;

  ContractMemberResponseModel({
    this.clauseName,
    this.clauseDetails,
  });

  factory ContractMemberResponseModel.fromJson(Map<String, dynamic> json) => ContractMemberResponseModel(
    clauseName: json["clauseName"],
    clauseDetails: json["clauseDetails"],
  );

  Map<String, dynamic> toJson() => {
    "clauseName": clauseName,
    "clauseDetails": clauseDetails,
  };
}