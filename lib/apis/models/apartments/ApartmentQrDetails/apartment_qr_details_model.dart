import 'dart:convert';

import 'package:vivas/apis/models/contract/check_in_details/check_in_details_response.dart';

ApartmentQrDetailsModel apartmentQrDetailsModelFromJson(String str) =>
    ApartmentQrDetailsModel.fromJson(json.decode(str));

String apartmentQrDetailsModelToJson(ApartmentQrDetailsModel data) =>
    json.encode(data.toJson());

class ApartmentQrDetailsModel {
  String? bedId;
  String? apartmentId;
  String? bookingId;
  num? apartmentPersonsNo;
  CheckInDetailsResponse? checkInRules;
  ExtendContract? extendContract;

  ApartmentQrDetailsModel({
    this.bedId,
    this.bookingId,
    this.apartmentId,
    this.apartmentPersonsNo,
    this.checkInRules,
    this.extendContract,
  });

  factory ApartmentQrDetailsModel.fromJson(Map<String, dynamic> json) =>
      ApartmentQrDetailsModel(
        bedId: json["bed_ID"],
        bookingId: json["booking_ID"],
        apartmentId: json["apartment_ID"],
        apartmentPersonsNo: json["apartment_Persons_No"],
        checkInRules: json["check_In_Rules"] == null
            ? null
            : CheckInDetailsResponse.fromJson(json["check_In_Rules"]),
        extendContract: json["extend_Contract"] == null
            ? null
            : ExtendContract.fromJson(json["extend_Contract"]),
      );

  Map<String, dynamic> toJson() => {
        "bed_ID": bedId,
        "booking_ID": bookingId,
        "apartment_ID": apartmentId,
        "apartment_Persons_No": apartmentPersonsNo,
        "extend_Contract": extendContract,
      };
}

class ExtendContract {
  String? id;
  String? bookingId;
  String? guestId;
  DateTime? extendingFrom;
  DateTime? extendingTo;
  String? extendingStatus;
  String? extendingRejectReason;
  String? extendContract;
  String? extendContractSignature;
  DateTime? extendContractSignedAt;
  bool? extendContractSigned;

  ExtendContract({
    this.id,
    this.bookingId,
    this.guestId,
    this.extendingFrom,
    this.extendingTo,
    this.extendingStatus,
    this.extendingRejectReason,
    this.extendContract,
    this.extendContractSignature,
    this.extendContractSignedAt,
    this.extendContractSigned,
  });

  factory ExtendContract.fromJson(Map<String, dynamic> json) => ExtendContract(
        id: json["id"],
        bookingId: json["booking_ID"],
        guestId: json["guest_ID"],
        extendingFrom: json["extending_From"] == null
            ? null
            : DateTime.parse(json["extending_From"]),
        extendingTo: json["extending_To"] == null
            ? null
            : DateTime.parse(json["extending_To"]),
        extendingStatus: json["extending_Status"],
        extendingRejectReason: json["extending_Reject_Reason"],
        extendContract: json["extend_Contract"],
        extendContractSignature: json["extend_Contract_Signature"],
        extendContractSignedAt: json["extend_Contract_Signed_At"] == null
            ? null
            : DateTime.parse(json["extend_Contract_Signed_At"]),
        extendContractSigned: json["extend_Contract_Signed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_ID": bookingId,
        "guest_ID": guestId,
        "extending_From": extendingFrom?.toIso8601String(),
        "extending_To": extendingTo?.toIso8601String(),
        "extending_Status": extendingStatus,
        "extending_Reject_Reason": extendingRejectReason,
        "extend_Contract": extendContract,
        "extend_Contract_Signature": extendContractSignature,
        "extend_Contract_Signed_At": extendContractSignedAt?.toIso8601String(),
        "extend_Contract_Signed": extendContractSigned,
      };
}
