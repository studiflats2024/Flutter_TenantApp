import 'dart:convert';

import 'package:vivas/apis/models/contract/check_in_details/check_in_details_response.dart';

ApartmentQrDetailsModel apartmentQrDetailsModelFromJson(String str) => ApartmentQrDetailsModel.fromJson(json.decode(str));

String apartmentQrDetailsModelToJson(ApartmentQrDetailsModel data) => json.encode(data.toJson());

class ApartmentQrDetailsModel {
  String? bedId;
  String? apartmentId;
  String? bookingId;
  num? apartmentPersonsNo;
  CheckInDetailsResponse? checkInRules;
  String? extendContract;

  ApartmentQrDetailsModel({
    this.bedId,
    this.bookingId,
    this.apartmentId,
    this.apartmentPersonsNo,
    this.checkInRules,
    this.extendContract,
  });

  factory ApartmentQrDetailsModel.fromJson(Map<String, dynamic> json) => ApartmentQrDetailsModel(
    bedId: json["bed_ID"],
    bookingId: json["booking_ID"],
    apartmentId: json["apartment_ID"],
    apartmentPersonsNo: json["apartment_Persons_No"],
    checkInRules: json["check_In_Rules"] == null ? null :  CheckInDetailsResponse.fromJson(json["check_In_Rules"]),
    extendContract: json["extend_Contract"],
  );

  Map<String, dynamic> toJson() => {
    "bed_ID": bedId,
    "booking_ID": bookingId,
    "apartment_ID": apartmentId,
    "apartment_Persons_No" : apartmentPersonsNo,
    "extend_Contract": extendContract,
  };
}


