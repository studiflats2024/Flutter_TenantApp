import 'dart:convert';

ContractModel contractModelFromJson(String str) =>
    ContractModel.fromJson(json.decode(str));

String contractModelToJson(ContractModel data) => json.encode(data.toJson());

class ContractModel {
  String? contractID;
  String? checkInDate;
  String? checkOutDate;
  num? rentMonthly;
  Map<String, String>? contractTerms;

  ContractModel({
    this.contractID,
    this.checkInDate,
    this.checkOutDate,
    this.rentMonthly,
    this.contractTerms,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
        contractID: json["contract_ID"],
        checkInDate: json["check_in_Date"],
        checkOutDate: json["check_out_Date"],
        rentMonthly: json["rent_Monthly"],
        contractTerms: Map<String, String>.from(json['contract_Terms']),
      );

  Map<String, dynamic> toJson() => {
        "contract_ID": contractID,
        "check_in_Date": checkInDate,
        "check_out_Date": checkOutDate,
        "rent_Monthly": rentMonthly,
        "contract_Terms": contractTerms,
      };
}
