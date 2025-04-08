// To parse this JSON data, do
//
//     final myPlanModel = myPlanModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivas/feature/Community/Data/Managers/subscription_enum.dart';

MyPlanModel myPlanModelFromJson(String str) =>
    MyPlanModel.fromJson(json.decode(str));

String myPlanModelToJson(MyPlanModel data) => json.encode(data.toJson());

class MyPlanModel {
  String? planName;
  String? planType;
  String? planDuration;
  num? invitationNOs;
  num? planPrice;
  num? planDiscount;
  num? planFianlPrice;
  num? planDurationInMonths;
  List<String?>? planFeatures;
  bool? isTrial;
  String? planSlug;
  String? startDate;
  String? endDate;
  SubscriptionStatus? subscriptionStatus;
  bool? contractSigned;
  String? contractPath;
  String? paymentMethod;
  String? paymentInvoiceId;
  bool? canUpgrade;

  DateTimeRange? dateTimeRange;

  MyPlanModel({
    this.planName,
    this.planType,
    this.planDuration,
    this.invitationNOs,
    this.planPrice,
    this.planDiscount,
    this.planFianlPrice,
    this.planFeatures,
    this.isTrial,
    this.planSlug,
    this.startDate,
    this.endDate,
    this.subscriptionStatus,
    this.paymentInvoiceId,
    this.dateTimeRange,
    this.contractSigned,
    this.contractPath,
    this.planDurationInMonths,
    this.paymentMethod,
    this.canUpgrade
  });

  factory MyPlanModel.fromJson(Map<String, dynamic> json) => MyPlanModel(
        planName: json["plan_Name"],
        planType: json["plan_Type"],
        planDuration: json["plan_Duration"],
        invitationNOs: json["invitation_NOs"],
        planPrice: json["plan_Price"],
        planDiscount: json["plan_Discount"],
        planFianlPrice: json["plan_Fianl_Price"],
        planFeatures: json["plan_Features"] == null
            ? []
            : List<String>.from(json["plan_Features"]!.map((x) => x)),
        isTrial: json["is_Trial"],
        planSlug: json["plan_Slug"],
        startDate: json["start_Date"],
        endDate: json["end_Date"],
        subscriptionStatus:
            SubscriptionStatus.fromValue(json["subscription_Status"]),
        paymentInvoiceId: json["payment_Invoice_ID"],
        planDurationInMonths: json["planDurationInMonths"],
        contractSigned: json["contract_Signed"],
        contractPath: json["contract_Path"],
        paymentMethod: json["payment_Method"],
        dateTimeRange: json["end_Date"] != null && json["end_Date"] != ''
            ? DateTimeRange(
                start: DateTime.now(),
                end: DateFormat("MM/dd/yyyy")
                    .parse(json["end_Date"])
                    .add(const Duration(days: 1)),
              )
            : null,
    canUpgrade: json["can_Upgrade"],
      );

  Map<String, dynamic> toJson() => {
        "plan_Name": planName,
        "plan_Type": planType,
        "plan_Duration": planDuration,
        "invitation_NOs": invitationNOs,
        "plan_Price": planPrice,
        "plan_Discount": planDiscount,
        "plan_Fianl_Price": planFianlPrice,
        "plan_Features": planFeatures == null
            ? []
            : List<dynamic>.from(planFeatures!.map((x) => x)),
        "is_Trial": isTrial,
        "plan_Slug": planSlug,
        "start_Date": startDate,
        "end_Date": endDate,
        "subscription_Status": subscriptionStatus,
        "payment_Invoice_ID": paymentInvoiceId,
        "planDurationInMonths": planDurationInMonths,
        "contract_Path": contractPath,
        "contract_Signed": contractSigned,
      "payment_Method": paymentMethod,
        "can_Upgrade": canUpgrade,
      };
}
