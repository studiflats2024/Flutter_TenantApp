import 'dart:convert';

InvoiceModel invoiceModelFromJson(String str) => InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  String? invoiceId;
  String? apartmentName;
  String? bedDetails;
  String? invoiceCode;
  String? invoiceIssueDate;
  String? invoiceStartDate;
  String? invoiceEndDate;
  num? secuirtyDeposit;
  num? serviceFees;
  num? invoiceTotal;
  String? invoiceUrl;
  bool? isSecuirtyRequired;

  InvoiceModel({
    this.invoiceId,
    this.apartmentName,
    this.bedDetails,
    this.invoiceCode,
    this.invoiceIssueDate,
    this.invoiceStartDate,
    this.invoiceEndDate,
    this.secuirtyDeposit,
    this.serviceFees,
    this.invoiceTotal,
    this.invoiceUrl,
    this.isSecuirtyRequired,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    invoiceId: json["invoice_ID"],
    apartmentName: json["apartment_Name"],
    bedDetails: json["bed_Details"],
    invoiceCode: json["invoice_Code"],
    invoiceIssueDate: json["invoice_Issue_Date"],
    invoiceStartDate: json["invoice_Start_Date"],
    invoiceEndDate: json["invoice_End_Date"],
    secuirtyDeposit: json["secuirty_Deposit"],
    serviceFees: json["service_Fees"],
    invoiceTotal: json["invoice_Total"],
    invoiceUrl: json["invoice_Url"],
    isSecuirtyRequired: json["is_Secuirty_Required"],
  );

  Map<String, dynamic> toJson() => {
    "invoice_ID": invoiceId,
    "apartment_Name": apartmentName,
    "bed_Details": bedDetails,
    "invoice_Code": invoiceCode,
    "invoice_Issue_Date": invoiceIssueDate,
    "invoice_Start_Date": invoiceStartDate,
    "invoice_End_Date": invoiceEndDate,
    "secuirty_Deposit": secuirtyDeposit,
    "service_Fees": serviceFees,
    "invoice_Total": invoiceTotal,
    "invoice_Url": invoiceUrl,
    "is_Secuirty_Required": isSecuirtyRequired,
  };
}
