import 'dart:convert';

InvoiceRentModel invoiceRentModelFromJson(String str) =>
    InvoiceRentModel.fromJson(json.decode(str));

String invoiceRentModelToJson(InvoiceRentModel data) =>
    json.encode(data.toJson());

class InvoiceRentModel {
  List<String>? invoiceCode;
  String? apartmentName;
  String? invoiceName;
  String? issueDate;
  List<Guest>? guests;
  num? total;

  InvoiceRentModel({
    this.invoiceCode,
    this.apartmentName,
    this.invoiceName,
    this.issueDate,
    this.guests,
    this.total,
  });

  factory InvoiceRentModel.fromJson(Map<String, dynamic> json) =>
      InvoiceRentModel(
        invoiceCode: json["invoice_Code"] == null
            ? []
            : List<String>.from(
                    json["invoice_Code"]!.map((x) => x)),
        apartmentName: json["apartment_Name"],
        invoiceName: json["invoice_Name"],
        issueDate: json["issue_Date"],
        guests: json["guests"] == null
            ? []
            : List<Guest>.from(json["guests"]!.map((x) => Guest.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "invoice_Code": invoiceCode,
        "apartment_Name": apartmentName,
        "invoice_Name": invoiceName,
        "issue_Date": issueDate,
        "guests": guests == null
            ? []
            : List<dynamic>.from(guests!.map((x) => x.toJson())),
        "total": total,
      };
}

class Guest {
  String? guestName;
  String? roomType;
  String? bedNo;
  num? bedPrice;
  num? securityDeposit;
  num? serviceFee;
  num? subTotal;

  Guest({
    this.guestName,
    this.roomType,
    this.bedNo,
    this.bedPrice,
    this.securityDeposit,
    this.serviceFee,
    this.subTotal,
  });

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
        guestName: json["guest_Name"],
        roomType: json["room_Type"],
        bedNo: json["bed_No"],
        bedPrice: json["bed_Price"],
        securityDeposit: json["secuirty_Deposit"],
        serviceFee: json["service_Fee"],
        subTotal: json["sub_Total"],
      );

  Map<String, dynamic> toJson() => {
        "guest_Name": guestName,
        "room_Type": roomType,
        "bed_No": bedNo,
        "bed_Price": bedPrice,
        "secuirty_Deposit": securityDeposit,
        "service_Fee": serviceFee,
        "sub_Total": subTotal,
      };
}
