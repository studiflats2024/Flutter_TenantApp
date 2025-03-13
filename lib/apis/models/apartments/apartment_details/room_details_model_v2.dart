import 'dart:developer';

import 'package:flutter/material.dart';

class ApartmentRoom {
  String? roomId;
  String? roomType;
  String? roomQrCode;
  String? roomQrImg;
  bool? roomAvailable;
  int? bedsNo;
  double? bedPrice;
  double? roomPrice;
  double? roomSecurityFees;
  double? roomServiceFees;
  double? bedSecurityDeposit;
  bool isSelected;
  double? bedServiceFees;
  List<RoomBed>? roomBeds;

  ApartmentRoom(
      {this.roomId,
      this.roomType,
      this.roomQrCode,
      this.roomQrImg,
      this.roomAvailable,
      this.bedsNo,
      this.bedPrice,
      this.roomPrice = 0,
      this.roomSecurityFees = 0,
      this.roomServiceFees = 0,
      this.bedSecurityDeposit,
      this.bedServiceFees,
      this.roomBeds,
      this.isSelected = false});

  factory ApartmentRoom.fromJson(Map<String, dynamic> json) => ApartmentRoom(
        roomId: json["room_ID"],
        roomType: json["room_Type"],
        roomQrCode: json["room_QRCode"],
        roomQrImg: json["room_QR_Img"],
        roomAvailable: json["room_Available"],
        bedsNo: json["beds_No"],
        bedPrice: json["bed_Price"],
        roomPrice: json["beds_No"] != null && json["bed_Price"] != null
            ? json["beds_No"] * json["bed_Price"]
            : 0.0,
        roomSecurityFees:
            json["beds_No"] != null && json["bed_SecuirtyDeposit"] != null
                ? json["beds_No"] * json["bed_SecuirtyDeposit"]
                : 0.0,
        roomServiceFees:
            json["beds_No"] != null && json["bed_Service_Fees"] != null
                ? json["beds_No"] * json["bed_Service_Fees"]
                : 0.0,
        bedSecurityDeposit: json["bed_SecuirtyDeposit"],
        bedServiceFees: json["bed_Service_Fees"],
        roomBeds: json["room_Beds"] == null
            ? []
            : List<RoomBed>.from(
                json["room_Beds"]!.map((x) => RoomBed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "room_ID": roomId,
        "room_Type": roomType,
        "room_QRCode": roomQrCode,
        "room_QR_Img": roomQrImg,
        "room_Available": roomAvailable,
        "beds_No": bedsNo,
        "bed_Price": bedPrice,
        "bed_SecuirtyDeposit": bedSecurityDeposit,
        "bed_Service_Fees": bedServiceFees,
        "room_Beds": roomBeds == null
            ? []
            : List<dynamic>.from(roomBeds!.map((x) => x.toJson())),
      };

  bool get isBedRoom => roomType == "Bedroom";

  bool get allBedsSelected {
    bool allSelected = true;
    for (int x = 0; x < (roomBeds?.length ?? 0); x++) {
      if (!roomBeds![x].isSelected) {
        allSelected = false;
      }
    }
    return allSelected;
  }

  bool get haveBedsSelected {
    bool haveBedsSelected = false;
    for (int x = 0; x < (roomBeds?.length ?? 0); x++) {
      if (roomBeds![x].isSelected) {
        haveBedsSelected = true;
        break;
      }
    }
    return haveBedsSelected;
  }

  bool get haveUnAvailableBeds {
    bool haveUnAvailableBed = false;
    for (int x = 0; x < roomBeds!.length; x++) {
      if (!(roomBeds![x].bedAvailable ?? false)) {
        haveUnAvailableBed = true;
        break;
      }
    }
    return haveUnAvailableBed;
  }

  bool haveUnAvailableBedsByRangeDate(
      DateTimeRange range, DateTimeRange contractRange) {
    bool haveUnAvailableBed = false;
    if ((roomBeds?.isNotEmpty ?? false) && bedsNo == roomBeds!.length) {
      for (int x = 0; x < roomBeds!.length; x++) {
        if (!(roomBeds![x].bedAvailableByDateRange(range, contractRange) ??
            false)) {
          haveUnAvailableBed = true;
          break;
        }
      }
    } else {
      haveUnAvailableBed = true;
    }

    return haveUnAvailableBed;
  }

  double get totalBedsSelected {
    double totalSelected = 0.0;

    for (int x = 0; x < (roomBeds?.length ?? 0); x++) {
      if (roomBeds![x].isSelected) {
        totalSelected += bedPrice ?? 0.0;
      }
    }
    return totalSelected;
  }

  double get totalSecurityDepositBedsSelected {
    double totalSelected = 0.0;

    for (int x = 0; x < (roomBeds?.length ?? 0); x++) {
      if (roomBeds![x].isSelected) {
        totalSelected += bedSecurityDeposit ?? 0.0;
      }
    }
    return totalSelected;
  }

  double get totalServiceBedsSelected {
    double totalSelected = 0.0;

    for (int x = 0; x < (roomBeds?.length ?? 0); x++) {
      if (roomBeds![x].isSelected) {
        totalSelected += bedServiceFees ?? 0.0;
      }
    }
    return totalSelected;
  }

  int get countOfSelectedBed {
    int count = 0;
    for (int x = 0; x < roomBeds!.length; x++) {
      if (roomBeds![x].isSelected) {
        count += 1;
      }
    }
    return count;
  }

  int get countOfAvailableBed {
    int count = 0;
    for (int x = 0; x < roomBeds!.length; x++) {
      if (roomBeds![x].bedsBookedDates!.isEmpty) {
        count += 1;
      }
    }
    return count;
  }

  int countOfAvailableBedByDateRange(
      DateTimeRange range, DateTimeRange contractRange) {
    int count = 0;

    for (int x = 0; x < roomBeds!.length; x++) {
      if (roomBeds![x].bedAvailableByDateRange(range, contractRange)) {
        count += 1;
      }
      /*   if (roomBeds![x].bedsBookedDates!.isEmpty) {
        count += 1;
      } else {
        for (int z = 0; z < roomBeds![x].bedsBookedDates!.length; z++) {
          var dates = roomBeds![x].bedsBookedDates!;
          if (z == (dates.length - 1)) {
            if (range.start.isAfter(dates[z].to!) &&
                range.end.isAfter(dates[z].to!)) {
              count += 1;
            } else if (range.start.isAfter(contractRange.start) &&
                range.end.isBefore(dates[z].from!)) {
              count +=1;
            }
          } else {
            if (range.start.isAfter(dates[z].to!) &&
                range.end.isAfter(dates[z].to!) &&
                range.start.isBefore(dates[z + 1].from!) &&
                range.end.isBefore(dates[z + 1].from!)) {
              count += 1;
            }
          }
        }
      }*/
    }
    return count;
  }
}

class RoomBed {
  String? roomName;
  String? roomId;
  String? bedId;
  String? bedQrCode;
  String? bedQrImg;
  DateTime? bedAvailableFrom;
  DateTime? bedAvailableTo;
  int? bedNo;
  bool? bedAvailable;
  bool isSelected;
  List<BedsBookedDate>? bedsBookedDates;

  RoomBed(
      {this.roomName,
      this.roomId,
      this.bedId,
      this.bedQrCode,
      this.bedQrImg,
      this.bedAvailableFrom,
      this.bedAvailableTo,
      this.bedNo,
      this.bedAvailable,
      this.bedsBookedDates,
      this.isSelected = false});

  factory RoomBed.fromJson(Map<String, dynamic> json) => RoomBed(
        roomId: json["room_ID"],
        bedId: json["bed_ID"],
        bedQrCode: json["bed_QRCode"],
        bedQrImg: json["bed_QR_Img"],
        bedNo: json["bed_No"],
        bedAvailable: json["bed_Available"],
        bedsBookedDates: json["beds_Booked_Dates"] == null
            ? []
            : List<BedsBookedDate>.from(json["beds_Booked_Dates"]!
                .map((x) => BedsBookedDate.fromJson(x))),
        // bedAvailableFrom: DateTime.tryParse(json["bed_Available_From"]),
        // bedAvailableTo: DateTime.tryParse(json["bed_Available_To"]),
      );

  Map<String, dynamic> toJson() => {
        "room_ID": roomId,
        "bed_ID": bedId,
        "bed_QRCode": bedQrCode,
        "bed_QR_Img": bedQrImg,
        "bed_No": bedNo,
        "bed_Available": bedAvailable,
        "bed_Available_To": bedAvailableTo,
        "bed_Available_From": bedAvailableFrom,
        "beds_Booked_Dates": bedsBookedDates == null
            ? []
            : List<dynamic>.from(bedsBookedDates!.map((x) => x.toJson())),
      };

  bool bedAvailableByDateRange(
      DateTimeRange range, DateTimeRange contractRange) {
    bool _bedAv = false;
    if (bedsBookedDates!.isEmpty) {
      _bedAv = true;
    } else {
      for (int z = 0; z < bedsBookedDates!.length; z++) {
        var dates = bedsBookedDates!;
        if ((dates[z].from!.month >= range.start.month &&
                bedsBookedDates!.length > 1) ||
            dates[z].from!.month <= range.start.month) {

          if (z == (dates.length - 1)) {
            if (range.start.isAfter(dates[z].to!) &&
                range.end.isAfter(dates[z].to!)) {
              _bedAv = true;
            } else if (range.start.isAfter(contractRange.start) &&
                range.end.isBefore(dates[z].from!) &&
                range.end.isBefore(dates[z].to!)) {
              _bedAv = true;
            }
          } else {
            if (range.start.isAfter(dates[z].to!) &&
                range.end.isAfter(dates[z].to!) &&
                range.start.isBefore(dates[z + 1].from!) &&
                range.end.isBefore(dates[z + 1].from!)) {
              _bedAv = true;
            }
          }
        } else {
          _bedAv = true;
        }
      }
    }
    return _bedAv;
  }
}

class BedsBookedDate {
  DateTime? from;
  DateTime? to;
  List<String>? months;

  BedsBookedDate({
    this.from,
    this.to,
    this.months,
  });

  factory BedsBookedDate.fromJson(Map<String, dynamic> json) => BedsBookedDate(
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
        months: json["months"] == null
            ? []
            : List<String>.from(json["months"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "from":
            "${from!.year.toString().padLeft(4, '0')}-${from!.month.toString().padLeft(2, '0')}-${from!.day.toString().padLeft(2, '0')}",
        "to":
            "${to!.year.toString().padLeft(4, '0')}-${to!.month.toString().padLeft(2, '0')}-${to!.day.toString().padLeft(2, '0')}",
        "months":
            months == null ? [] : List<dynamic>.from(months!.map((x) => x)),
      };

  DateTimeRange get range {
    return DateTimeRange(start: from!, end: to!);
  }
}
