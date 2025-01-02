import 'dart:convert';

ApartmentRulesResponseModel apartmentRulesResponseModelFromJson(String str) => ApartmentRulesResponseModel.fromJson(json.decode(str));

String apartmentRulesResponseModelToJson(ApartmentRulesResponseModel data) => json.encode(data.toJson());

class ApartmentRulesResponseModel {
  String? rentRulesId;
  List<String>? rules;

  ApartmentRulesResponseModel({
    this.rentRulesId,
    this.rules,
  });

  factory ApartmentRulesResponseModel.fromJson(Map<String, dynamic> json) => ApartmentRulesResponseModel(
    rentRulesId: json["rent_Rules_ID"],
    rules: json["rules"] == null ? [] : List<String>.from(json["rules"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "rent_Rules_ID": rentRulesId,
    "rules": rules == null ? [] : List<dynamic>.from(rules!.map((x) => x)),
  };
}
