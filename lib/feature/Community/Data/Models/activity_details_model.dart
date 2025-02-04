import 'dart:convert';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';

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
  String? activityLocation;
  String? activityDate;
  num? activityRating;
  num? ratingCount;
  bool? activityIsWish;
  String? activityTime;
  List<String>? subscripersPhotos;
  List<SessionsCourseWorkshop>? sessionsCourseWorkshop;
  List<Rating>? ratings;
  List<SessionsConsult>? sessionsConsults;

  ActivityDetailsModel({
    this.activityId,
    this.activityMedia,
    this.activityType,
    this.activityName,
    this.activityDescription,
    this.activitySeats,
    this.activityLocation,
    this.activityDate,
    this.activityRating,
    this.ratingCount,
    this.activityIsWish,
    this.activityTime,
    this.subscripersPhotos,
    this.sessionsCourseWorkshop,
    this.ratings,
    this.sessionsConsults,
  });

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
        activityLocation: json["activity_Location"],
        activityDate: json["activity_Date"],
        activityRating: json["activity_Rating"],
        ratingCount: json["rating_Count"],
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
      );

  Map<String, dynamic> toJson() => {
        "activity_ID": activityId,
        "activity_Media": activityMedia,
        "activity_Type": activityType,
        "activity_Name": activityName,
        "activity_Description": activityDescription,
        "activity_Seats": activitySeats,
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
      };
}

class Rating {
  String? userName;
  String? userPhoto;
  String? ratingDate;
  int? ratingValue;
  String? comment;

  Rating({
    this.userName,
    this.userPhoto,
    this.ratingDate,
    this.ratingValue,
    this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        userName: json["userName"],
        userPhoto: json["user_Photo"],
        ratingDate: json["rating_Date"],
        ratingValue: json["rating_Value"],
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
