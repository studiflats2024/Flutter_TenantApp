// To parse this JSON data, do
//
//     final invitationsHistoryModel = invitationsHistoryModelFromJson(jsonString);

import 'dart:convert';

InvitationsHistoryModel invitationsHistoryModelFromJson(String str) => InvitationsHistoryModel.fromJson(json.decode(str));

String invitationsHistoryModelToJson(InvitationsHistoryModel data) => json.encode(data.toJson());

class InvitationsHistoryModel {
  int? totalRecords;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  List<InviteModel>? data;
  String? nextPage;
  String? previousPage;
  String? firstPage;
  String? lastPage;
  bool? hasNextPage;
  bool? hasPreviousPage;

  InvitationsHistoryModel({
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

  factory InvitationsHistoryModel.fromJson(Map<String, dynamic> json) => InvitationsHistoryModel(
    totalRecords: json["totalRecords"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    pageSize: json["pageSize"],
    data: json["data"] == null ? [] : List<InviteModel>.from(json["data"]!.map((x) => InviteModel.fromJson(x))),
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
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "nextPage": nextPage,
    "previousPage": previousPage,
    "firstPage": firstPage,
    "lastPage": lastPage,
    "hasNextPage": hasNextPage,
    "hasPreviousPage": hasPreviousPage,
  };
}

class InviteModel {
  String? inviteId;
  String? name;
  String? email;
  String? phone;
  DateTime? date;

  InviteModel({
    this.inviteId,
    this.name,
    this.email,
    this.phone,
    this.date,
  });

  factory InviteModel.fromJson(Map<String, dynamic> json) => InviteModel(
    inviteId: json["invite_ID"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "invite_ID": inviteId,
    "name": name,
    "email": email,
    "phone" :"phone",
    "date": date?.toIso8601String(),
  };
}
