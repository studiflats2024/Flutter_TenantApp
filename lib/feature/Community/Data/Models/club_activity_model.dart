// To parse this JSON data, do
//
//     final clubActivityModel = clubActivityModelFromJson(jsonString);

import 'dart:convert';

import 'package:vivas/feature/Community/Data/Models/activity_model.dart';

ClubActivityModel clubActivityModelFromJson(String str) =>
    ClubActivityModel.fromJson(json.decode(str));

String clubActivityModelToJson(ClubActivityModel data) =>
    json.encode(data.toJson());

class ClubActivityModel {
  int? totalRecords;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  List<ActivitiesModel>? data;
  String? nextPage;
  String? previousPage;
  String? firstPage;
  String? lastPage;
  bool? hasNextPage;
  bool? hasPreviousPage;

  ClubActivityModel({
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

  factory ClubActivityModel.fromJson(Map<String, dynamic> json) =>
      ClubActivityModel(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        data: json["data"] == null
            ? []
            : List<ActivitiesModel>.from(
                json["data"]!.map((x) => ActivitiesModel.fromJson(x))),
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

class ActivitiesModel {
  String? activityId;
  String? activityMedia;
  ActivitiesType? activityType;
  String? activityName;
  num? activitySeats;
  String? activityLocation;
  String? activityDate;
  num? activityRating;
  num? ratingCount;
  bool? activityIsWish;
  String? activityTime;

  ActivitiesModel({
    this.activityId,
    this.activityMedia,
    this.activityType,
    this.activityName,
    this.activitySeats,
    this.activityLocation,
    this.activityDate,
    this.activityRating,
    this.ratingCount,
    this.activityIsWish,
    this.activityTime,
  });

  factory ActivitiesModel.fromJson(Map<String, dynamic> json) =>
      ActivitiesModel(
        activityId: json["activity_ID"],
        activityMedia: json["activity_Media"],
        activityType: json["activity_Type"] != null
            ? ActivitiesType.fromValue(json["activity_Type"])
            : null,
        activityName: json["activity_Name"],
        activitySeats: json["activity_Seats"],
        activityLocation: json["activity_Location"],
        activityDate: json["activity_Date"],
        activityRating: json["activity_Rating"],
        ratingCount: json["rating_Count"],
        activityIsWish: json["activity_Is_Wish"],
        activityTime: json["activity_Time"],
      );

  Map<String, dynamic> toJson() => {
        "activity_ID": activityId,
        "activity_Media": activityMedia,
        "activity_Type": activityType?.code,
        "activity_Name": activityName,
        "activity_Seats": activitySeats,
        "activity_Location": activityLocation,
        "activity_Date": activityDate,
        "activity_Rating": activityRating,
        "rating_Count": ratingCount,
        "activity_Is_Wish": activityIsWish,
        "activity_Time": activityTime,
      };
}
