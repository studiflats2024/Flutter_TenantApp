// To parse this JSON data, do
//
//     final planDetailsModel = planDetailsModelFromJson(jsonString);

import 'dart:convert';

PlanDetailsModel planDetailsModelFromJson(String str) =>
    PlanDetailsModel.fromJson(json.decode(str));

String planDetailsModelToJson(PlanDetailsModel data) =>
    json.encode(data.toJson());

class PlanDetailsModel {
  String? id;
  String? planName;
  String? planType;
  String? planDuration;
  num? invitationNOs;
  num? planPrice;
  num? planDiscount;
  num? planFianlPrice;
  String? planFeaturesJson;
  List<String>? planFeatures;
  num? planDurationInMonths;
  bool? isTrial;
  String? startDate;
  String? endDate;
  String? subscriptionStatus;
  String? paymentInvoiceId;
  bool? hasPlan;

  PlanDetailsModel({
    this.id,
    this.planName,
    this.planType,
    this.planDuration,
    this.invitationNOs,
    this.planPrice,
    this.planDiscount,
    this.planFianlPrice,
    this.planFeaturesJson,
    this.planFeatures,
    this.planDurationInMonths,
    this.isTrial,
    this.startDate,
    this.endDate,
    this.paymentInvoiceId,
    this.subscriptionStatus,
    this.hasPlan,
  });

  factory PlanDetailsModel.fromJson(Map<String, dynamic> json) =>
      PlanDetailsModel(
          id: json["id"],
          planName: json["plan_Name"],
          planType: json["plan_Type"],
          planDuration: json["plan_Duration"],
          invitationNOs: json["invitation_NOs"],
          planPrice: json["plan_Price"],
          planDiscount: json["plan_Discount"],
          planFianlPrice: json["plan_Fianl_Price"],
          planFeaturesJson: json["plan_FeaturesJson"],
          planFeatures: json["plan_Features"] == null
              ? []
              : List<String>.from(json["plan_Features"]!.map((x) => x)),
          planDurationInMonths: json["planDurationInMonths"],
          isTrial: json["is_Trial"],
          startDate: json["start_Date"],
          endDate: json["end_Date"],
          subscriptionStatus: json["subscription_Status"],
          paymentInvoiceId: json["payment_Invoice_ID"],
          hasPlan: json["has_Plan"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_Name": planName,
        "plan_Type": planType,
        "plan_Duration": planDuration,
        "invitation_NOs": invitationNOs,
        "plan_Price": planPrice,
        "plan_Discount": planDiscount,
        "plan_Fianl_Price": planFianlPrice,
        "plan_FeaturesJson": planFeaturesJson,
        "plan_Features": planFeatures == null
            ? []
            : List<dynamic>.from(planFeatures!.map((x) => x)),
        "planDurationInMonths": planDurationInMonths,
        "is_Trial": isTrial,
        "start_Date": startDate,
        "end_Date": endDate,
        "subscription_Status": subscriptionStatus,
        "payment_Invoice_ID": paymentInvoiceId,
      };
}
