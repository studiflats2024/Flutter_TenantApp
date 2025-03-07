import 'dart:convert';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Managers/subscription_enum.dart';
import 'package:vivas/feature/Community/Data/Models/consult_subscription.dart';

ActivityDetailsModel activityDetailsModelFromJson(String str) =>
    ActivityDetailsModel.fromJson(json.decode(str));

String activityDetailsModelToJson(ActivityDetailsModel data) =>
    json.encode(data.toJson());

class ActivityDetailsModel {
  String? activityId;
  String? activityMedia;
  ActivitiesType? activityType;
  String? activityName;
  String? activityDescription;
  num? activitySeats;
  num? availableSeats;
  String? activityLocation;
  String? activityDate;
  String? postponedTo;
  String? activityStartDate;
  String? activityEndDate;
  num? activityRating;
  num? ratingCount;
  num? latitude;
  num? longitude;
  bool? activityIsWish;
  String? activityTime;
  String? invId;
  List<String>? subscripersPhotos;
  List<SessionsCourseWorkshop>? sessionsCourseWorkshop;
  List<Rating>? ratings;
  List<SessionsConsult>? sessionsConsults;
  List<ConsultDay>? consultDays;
  List<ConsultSubscription>? consultSubscriptions;
  bool? hasEnrolled;
  bool? hasPlan;
  SubscriptionStatus? subscriptionStatus;

  ActivityDetailsModel(
      {this.activityId,
      this.activityMedia,
      this.activityType,
      this.activityName,
      this.activityDescription,
      this.activitySeats,
      this.availableSeats,
      this.activityLocation,
      this.activityDate,
      this.postponedTo,
      this.activityStartDate,
      this.activityEndDate,
      this.activityRating,
      this.ratingCount,
      this.latitude,
      this.longitude,
      this.activityIsWish,
      this.activityTime,
      this.subscripersPhotos,
      this.sessionsCourseWorkshop,
      this.ratings,
      this.sessionsConsults,
      this.consultDays,
      this.hasEnrolled,
      this.hasPlan,
      this.consultSubscriptions,
      this.subscriptionStatus,
      this.invId});

  factory ActivityDetailsModel.fromJson(Map<String, dynamic> json) =>
      ActivityDetailsModel(
        activityId: json["activity_ID"],
        activityMedia: json["activity_Media"],
        activityType: json["activity_Type"] != null
            ? ActivitiesType.fromValue(json["activity_Type"])
            : null,
        activityName: json["activity_Name"],
        activityDescription: json["activity_Description"],
        activitySeats: json["activity_Seats"],
        availableSeats: num.parse(json["available_Seats"]),
        activityLocation: json["activity_Location"],
        activityDate: json["activity_Date"],
        postponedTo: json["postponed_To"] == null || json["postponed_To"] == ""
            ? null
            : json["postponed_To"],
        activityStartDate: json["activity_Start_Date"],
        activityEndDate: json["activity_End_Date"],
        activityRating: json["activity_Rating"],
        ratingCount: json["rating_Count"],
        latitude: json["lat"],
        longitude: json["long"],
        activityIsWish: json["activity_Is_Wish"],
        activityTime: json["activity_Time"],
        subscripersPhotos: json["subscripers_Photos"] == null
            ? []
            : List<String>.from(json["subscripers_Photos"]!.map((x) => x)),
        sessionsCourseWorkshop: json["sessions_Course_Workshop"] == null
            ? []
            : List<SessionsCourseWorkshop>.from(
                json["sessions_Course_Workshop"]!
                    .map((x) => SessionsCourseWorkshop.fromJson(x))),
        ratings: json["ratings"] == null
            ? []
            : List<Rating>.from(
                json["ratings"]!.map((x) => Rating.fromJson(x))),
        sessionsConsults: json["sessions_Consults"] == null
            ? []
            : List<SessionsConsult>.from(json["sessions_Consults"]!
                .map((x) => SessionsConsult.fromJson(x))),
        consultDays: json["consult_Days"] == null
            ? []
            : List<ConsultDay>.from(
                json["consult_Days"]!.map((x) => ConsultDay.fromJson(x))),
        hasEnrolled: json["has_Enrolled"] ?? false,
        hasPlan: json["has_Plan"] ?? false,
        consultSubscriptions: json["consult_subscription"] == null
            ? []
            : List<ConsultSubscription>.from(json["consult_subscription"]!
                .map((x) => ConsultSubscription.fromJson(x))),
        subscriptionStatus:
            SubscriptionStatus.fromValue(json["plan_Status"] ?? ""),
        invId: json["inv_ID"],
      );

  Map<String, dynamic> toJson() => {
        "activity_ID": activityId,
        "activity_Media": activityMedia,
        "activity_Type": activityType,
        "activity_Name": activityName,
        "activity_Description": activityDescription,
        "activity_Seats": activitySeats,
        "available_Seats": availableSeats,
        "activity_Location": activityLocation,
        "activity_Date": activityDate,
        "activity_Rating": activityRating,
        "rating_Count": ratingCount,
        "activity_Is_Wish": activityIsWish,
        "activity_Time": activityTime,
        "subscripers_Photos": subscripersPhotos == null
            ? []
            : List<dynamic>.from(subscripersPhotos!.map((x) => x)),
        "sessions_Course_Workshop": sessionsCourseWorkshop == null
            ? []
            : List<dynamic>.from(
                sessionsCourseWorkshop!.map((x) => x.toJson())),
        "ratings": ratings == null
            ? []
            : List<dynamic>.from(ratings!.map((x) => x.toJson())),
        "sessions_Consults": sessionsConsults == null
            ? []
            : List<dynamic>.from(sessionsConsults!.map((x) => x.toJson())),
        "has_Enrolled": hasEnrolled,
        "has_Plan": hasPlan,
        "consult_subscription": consultSubscriptions == null
            ? []
            : List<dynamic>.from(consultSubscriptions!.map((x) => x.toJson())),
        "subscription_Status": subscriptionStatus?.name,
      };
}

class Rating {
  String? userName;
  String? userPhoto;
  String? ratingDate;
  num? ratingValue;
  String? comment;

  Rating({
    this.userName,
    this.userPhoto,
    this.ratingDate,
    this.ratingValue,
    this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        userName: json["name"],
        userPhoto: json["photo"],
        ratingDate: json["date"],
        ratingValue: json["rating"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "user_Photo": userPhoto,
        "rating_Date": ratingDate,
        "rating_Value": ratingValue,
        "comment": comment,
      };
}

class SessionsConsult {
  String? sessionId;
  String? sessionDay;
  String? sessionStartTime;
  String? sessionEndTime;
  int? sessionDuration;
  bool? hasPublished;
  int? seessionAvailableSeats;

  SessionsConsult({
    this.sessionId,
    this.sessionDay,
    this.sessionStartTime,
    this.sessionEndTime,
    this.sessionDuration,
    this.hasPublished,
    this.seessionAvailableSeats,
  });

  factory SessionsConsult.fromJson(Map<String, dynamic> json) =>
      SessionsConsult(
        sessionId: json["session_ID"],
        sessionDay: json["session_Day"],
        sessionStartTime: json["session_Start_Time"],
        sessionEndTime: json["session_End_Time"],
        sessionDuration: json["session_Duration"],
        hasPublished: json["has_Published"],
        seessionAvailableSeats: json["seession_Available_Seats"],
      );

  Map<String, dynamic> toJson() => {
        "session_ID": sessionId,
        "session_Day": sessionDay,
        "session_Start_Time": sessionStartTime,
        "session_End_Time": sessionEndTime,
        "session_Duration": sessionDuration,
        "has_Published": hasPublished,
        "seession_Available_Seats": seessionAvailableSeats,
      };
}

class SessionsCourseWorkshop {
  String? sessionId;
  String? sessionTitle;
  DateTime? sessionDate;
  String? sessionLink;
  String? startTime;
  String? endTime;
  bool? hasPublished;

  SessionsCourseWorkshop({
    this.sessionId,
    this.sessionTitle,
    this.sessionDate,
    this.sessionLink,
    this.startTime,
    this.endTime,
    this.hasPublished,
  });

  factory SessionsCourseWorkshop.fromJson(Map<String, dynamic> json) =>
      SessionsCourseWorkshop(
        sessionId: json["session_ID"],
        sessionTitle: json["session_Title"],
        sessionDate: json["session_Date"] == null
            ? null
            : DateTime.parse(json["session_Date"]),
        sessionLink: json["session_Link"],
        startTime: json["start_Time"],
        endTime: json["end_Time"],
        // startTime: json["start_Time"] == null
        //     ? null
        //     : DateFormat.jm().format(DateTime.parse(json["start_Time"])),
        // endTime: json["end_Time"] == null
        //     ? null
        //     : DateFormat.jm().format(DateTime.parse(json["end_Time"])),
        hasPublished: json["has_Published"],
      );

  Map<String, dynamic> toJson() => {
        "session_ID": sessionId,
        "session_Title": sessionTitle,
        "session_Date": sessionDate?.toIso8601String(),
        "session_Link": sessionLink,
        "start_Time": startTime,
        "end_Time": endTime,
        "has_Published": hasPublished,
      };
}

class ConsultDay {
  String? consultDay;
  DateTime? consultDate;
  Map<String, ConsultTime>? consultTime;

  ConsultDay({
    this.consultDay,
    this.consultDate,
    this.consultTime,
  });

  factory ConsultDay.fromJson(Map<String, dynamic> json) => ConsultDay(
        consultDay: json["consult_Day"],
        consultDate: json["consult_Date"] == null
            ? null
            : DateTime.parse(json["consult_Date"]),
        consultTime: Map.from(json["consult_Time"]!).map((k, v) =>
            MapEntry<String, ConsultTime>(k, ConsultTime.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "consult_Day": consultDay,
        "consult_Date": consultDate?.toIso8601String(),
        "consult_Time": Map.from(consultTime!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class ConsultTime {
  String? timeRange;
  bool? isAvailable;

  ConsultTime({
    this.timeRange,
    this.isAvailable,
  });

  factory ConsultTime.fromJson(Map<String, dynamic> json) => ConsultTime(
        timeRange: json["timeRange"],
        isAvailable: json["isAvailable"],
      );

  Map<String, dynamic> toJson() => {
        "timeRange": timeRange,
        "isAvailable": isAvailable,
      };
}
