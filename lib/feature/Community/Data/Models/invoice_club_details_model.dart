import 'dart:convert';

InvoiceClubDetailsModel invoiceClubDetailsModelFromJson(String str) =>
    InvoiceClubDetailsModel.fromJson(json.decode(str));

String invoiceClubDetailsModelToJson(InvoiceClubDetailsModel data) =>
    json.encode(data.toJson());

class InvoiceClubDetailsModel {
  String? invoiceId;
  String? planName;
  String? planDuration;
  num? planDurationInMonth;
  num? subTotal;
  String? paymentDate;
  String? invoiceNo;
  String? paymentStatus;
  String? subscriptionStartDate;
  String? paymentMethod;
  String? renewelDate;
  num? vat;
  num? total;
  String? url;

  InvoiceClubDetailsModel(
      {this.invoiceId,
      this.planName,
      this.planDuration,
      this.planDurationInMonth,
      this.subTotal,
      this.paymentDate,
      this.invoiceNo,
      this.paymentStatus,
      this.subscriptionStartDate,
      this.renewelDate,
      this.vat,
      this.total,
        this.url,
      this.paymentMethod});

  factory InvoiceClubDetailsModel.fromJson(Map<String, dynamic> json) =>
      InvoiceClubDetailsModel(
        invoiceId: json["invoice_ID"],
        planName: json["plan_Name"],
        planDuration: json["plan_Duration"],
        planDurationInMonth: json["plan_DurationInMonth"],
        subTotal: json["sub_Total"],
        paymentDate: json["payment_Date"],
        invoiceNo: json["invoice_No"],
        paymentStatus: json["payment_Status"],
        subscriptionStartDate: json["subscription_Start_Date"],
        renewelDate: json["renewel_Date"],
        paymentMethod: json["payment_method"],
        vat: json["vat"],
        total: json["total"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "invoice_ID": invoiceId,
        "plan_Name": planName,
        "plan_Duration": planDuration,
        "plan_DurationInMonth": planDurationInMonth,
        "sub_Total": subTotal,
        "payment_Date": paymentDate,
        "invoice_No": invoiceNo,
        "payment_Status": paymentStatus,
        "subscription_Start_Date": subscriptionStartDate,
        "renewel_Date": renewelDate,
        "vat": vat,
        "total": total,
        "url": url,
        "payment_method": paymentMethod
      };
}
