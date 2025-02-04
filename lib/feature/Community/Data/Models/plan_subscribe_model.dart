// To parse this JSON data, do
//
//     final subscribePlanModel = subscribePlanModelFromJson(jsonString);

import 'dart:convert';

import 'package:vivas/feature/Community/Data/Models/plan_details_model.dart';

SubscribePlanModel subscribePlanModelFromJson(String str) => SubscribePlanModel.fromJson(json.decode(str));

String subscribePlanModelToJson(SubscribePlanModel data) => json.encode(data.toJson());

class SubscribePlanModel {
  String? message;
  String? id;
  String? invoiceId;
  PlanDetailsModel? plan;

  SubscribePlanModel({
    this.message,
    this.id,
    this.invoiceId,
    this.plan,
  });

  factory SubscribePlanModel.fromJson(Map<String, dynamic> json) => SubscribePlanModel(
    message: json["message"],
    id: json["id"],
    invoiceId: json["invoice_ID"],
    plan: json["plan"] == null ? null : PlanDetailsModel.fromJson(json["plan"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "id": id,
    "invoice_ID": invoiceId,
    "plan": plan?.toJson(),
  };
}

