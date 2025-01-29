import 'dart:convert';

List<SubscriptionPlansModel> subscriptionPlansModelFromJson(String str) =>
    List<SubscriptionPlansModel>.from(
        json.decode(str).map((x) => SubscriptionPlansModel.fromJson(x)));

String subscriptionPlansModelToJson(List<SubscriptionPlansModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionPlansModel {
  String? id;
  String? planName;
  String? planType;
  String? planDuration;
  num? invitationNOs;
  num? planPrice;
  num? planDiscount;
  num? planFianlPrice;
  List<String>? planFeatures;
  num? planDurationInMonths;
  num? currentSubscripers;
  num? renewedSubscripers;
  bool? isTrial;

  SubscriptionPlansModel({
    this.id,
    this.planName,
    this.planType,
    this.planDuration,
    this.invitationNOs,
    this.planPrice,
    this.planDiscount,
    this.planFianlPrice,
    this.planFeatures,
    this.planDurationInMonths,
    this.currentSubscripers,
    this.renewedSubscripers,
    this.isTrial,
  });

  factory SubscriptionPlansModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlansModel(
        id: json["id"],
        planName: json["plan_Name"],
        planType: json["plan_Type"],
        planDuration: json["plan_Duration"] != null
            ? json["plan_Duration"].toString().contains("/")
                ? json["plan_Duration"].toString().split("/").first
                : json["plan_Duration"]
            : null,
        invitationNOs: json["invitation_NOs"],
        planPrice: json["plan_Price"],
        planDiscount: json["plan_Discount"],
        planFianlPrice: json["plan_Fianl_Price"],
        planFeatures: json["plan_Features"] == null
            ? []
            : List<String>.from(json["plan_Features"]!.map((x) => x)),
        planDurationInMonths: json["planDurationInMonths"],
        currentSubscripers: json["current_Subscripers"],
        renewedSubscripers: json["renewed_Subscripers"],
        isTrial: json["is_Trial"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "planDurationInMonths": planDurationInMonths,
        "current_Subscripers": currentSubscripers,
        "renewed_Subscripers": renewedSubscripers,
        "is_Trial": isTrial,
      };
}
