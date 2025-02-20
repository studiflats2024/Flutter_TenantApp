import 'dart:convert';

PlanHistoryModel planHistoryModelFromJson(String str) =>
    PlanHistoryModel.fromJson(json.decode(str));

String planHistoryModelToJson(PlanHistoryModel data) =>
    json.encode(data.toJson());

class PlanHistoryModel {
  int? totalRecords;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  List<Plan>? data;
  String? nextPage;
  String? previousPage;
  String? firstPage;
  String? lastPage;
  bool? hasNextPage;
  bool? hasPreviousPage;

  PlanHistoryModel({
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

  factory PlanHistoryModel.fromJson(Map<String, dynamic> json) =>
      PlanHistoryModel(
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        data: json["data"] == null
            ? []
            : List<Plan>.from(json["data"]!.map((x) => Plan.fromJson(x))),
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

class Plan {
  String? invoiceId;
  String? planName;
  String? planDuration;
  num? planPrice;
  num? planDurationInMonths;
  String? paymentDate;
  String? invoiceNo;

  Plan({
    this.invoiceId,
    this.planName,
    this.planDuration,
    this.planPrice,
    this.planDurationInMonths,
    this.paymentDate,
    this.invoiceNo,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        invoiceId: json["invoice_ID"],
        planName: json["plan_Name"],
        planDuration: json["plan_Duration"],
        planPrice: json["plan_Price"],
        planDurationInMonths: json["plan_DurationInMonth"],
        paymentDate: json["payment_Date"],
        invoiceNo: json["invoice_No"],
      );

  Map<String, dynamic> toJson() => {
        "invoice_ID": invoiceId,
        "plan_Name": planName,
        "plan_Duration": planDuration,
        "plan_Price": planPrice,
        "planDurationInMonths": planDurationInMonths,
        "payment_Date": paymentDate,
        "invoice_No": invoiceNo,
      };
}
