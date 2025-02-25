// To parse this JSON data, do
//
//     final myActivityResponse = myActivityResponseFromJson(jsonString);

import 'dart:convert';

import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Models/consult_subscription.dart';

MyActivityResponse myActivityResponseFromJson(String str) =>
    MyActivityResponse.fromJson(json.decode(str));

String myActivityResponseToJson(MyActivityResponse data) =>
    json.encode(data.toJson());

class MyActivityResponse {
  int? totalRecords;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  List<MyActivitiesModel>? data;
  String? nextPage;
  String? previousPage;
  String? firstPage;
  String? lastPage;
  bool? hasNextPage;
  bool? hasPreviousPage;

  MyActivityResponse({
    this.totalRecords,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.data,
    this.nextPage,
    this.previousPage,
    this.firstPage,
    this.lastPage,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory MyActivityResponse.fromJson(Map<String, dynamic> json) =>
      MyActivityResponse(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        data: json["data"] == null
            ? []
            : List<MyActivitiesModel>.from(
                json["data"]!.map((x) => MyActivitiesModel.fromJson(x))),
        nextPage: json["nextPage"],
        previousPage: json["previousPage"],
        firstPage: json["firstPage"],
        lastPage: json["lastPage"],
        hasNextPage: json["hasNextPage"],
        hasPreviousPage: json["hasPreviousPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "pageSize": pageSize,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "nextPage": nextPage,
        "previousPage": previousPage,
        "firstPage": firstPage,
        "lastPage": lastPage,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
      };
}

class MyActivitiesModel {
  String? id;
  String? activityId;
  String? activityPhoto;
  ActivitiesType? activityType;
  String? activityName;
  String? activityDate;
  String? activityPostponedDate;
  int? reviews;
  String? activityStatus;
  bool? hasRated;
  List<ConsultSubscription>? consultSubscriptions;

  MyActivitiesModel(
      {this.id,
      this.activityId,
      this.activityPhoto,
      this.activityType,
      this.activityName,
      this.activityDate,
      this.activityPostponedDate,
      this.reviews,
      this.activityStatus,
      this.hasRated,
      this.consultSubscriptions});

  factory MyActivitiesModel.fromJson(Map<String, dynamic> json) =>
      MyActivitiesModel(
        id: json["id"],
        activityId: json["activity_ID"],
        activityPhoto: json["activity_Photo"],
        activityType: json["activity_Type"] != null
            ? ActivitiesType.fromType(json["activity_Type"])
            : null,
        activityName: json["activity_Name"],
        activityDate: json["activity_Date"],
        activityPostponedDate: json["postponed_To"],
        reviews: json["reviews"],
        activityStatus: json["activity_Status"],
        hasRated: json["has_Rated"],
        consultSubscriptions: json["consult_subscription"] == null
            ? []
            : List<ConsultSubscription>.from(json["consult_subscription"]!
                .map((x) => ConsultSubscription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "activity_ID": activityId,
        "activity_Photo": activityPhoto,
        "activity_Type": activityType,
        "activity_Name": activityName,
        "activity_Date": activityDate,
        "postponed_To": activityPostponedDate,
        "reviews": reviews,
        "activity_Status": activityStatus,
        "has_Rated": hasRated,
        "consult_subscription": consultSubscriptions == null
            ? []
            : List<dynamic>.from(consultSubscriptions!.map((x) => x.toJson())),
      };
}
