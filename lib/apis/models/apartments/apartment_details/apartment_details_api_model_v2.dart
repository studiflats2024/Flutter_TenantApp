import 'package:flutter/material.dart';
import 'package:vivas/apis/models/apartments/apartment_details/bathroom_details_model_v2.dart';
import 'package:vivas/apis/models/apartments/apartment_details/room_details_model_v2.dart';

class ApartmentDetailsApiModelV2 {
  String? apartmentId;
  String? apartmentCode;
  String? apartmentName;
  bool? apartmentAllBillIncluded;
  String? apartmentBillDescirption;
  String? apartmentStreetName;
  String? apartmentBuildingName;
  String? apartmentCity;
  String? apartmentArea;
  double? apartmentAreaSquare;
  String? apartmentLocation;
  int? apartmentFloor;
  int? apartmentNo;
  String? apartmentManager;
  String? apartmentOwner;
  List<ApartmentTransport>? apartmentTransports;
  bool? apartmentRentByApartment;
  bool? apartmentRentByBed;
  String? apartmentDescription;
  List<ApartmentImages>? apartmentImages;
  String? apartmentVideoLink;
  String? apartmentGoogleLocation;
  int? availableBeds;
  double? apartmentLat;
  double? apartmentLong;
  String? apartment360DLink;
  bool? apartmentSharedArea;
  String? apartmentSleepingArea;
  bool? apartmentElevator;
  String? apartmentType;
  int? apartmentBedRoomsNo;
  int? apartmentBathroomNo;
  List<ApartmentRoom>? apartmentRooms;
  List<RoomBed>? beds;
  String? apartmentQrCode;
  String? apartmentQrImg;
  String? apartmentStatus;
  String? apartmentSharedType;
  String? shareLink;
  List<BathroomDetail>? bathroomDetails;
  List<String>? kitchenDetails;
  List<String>? apartmentFeatures;
  List<String>? apartmentFacilites;
  bool? canMakeRequest;
  bool isWishlist;
  bool isSelectedFullApartment = false;
  DateTime? availableFrom;
  DateTime? availableTo;
  int? minStay;

  ApartmentDetailsApiModelV2({this.apartmentId,
    this.apartmentCode,
    this.apartmentName,
    this.availableBeds,
    this.apartmentAllBillIncluded,
    this.apartmentBillDescirption,
    this.apartmentStreetName,
    this.apartmentBuildingName,
    this.apartmentCity,
    this.apartmentArea,
    this.apartmentAreaSquare,
    this.apartmentLocation,
    this.apartmentFloor,
    this.apartmentNo,
    this.apartmentManager,
    this.apartmentOwner,
    this.apartmentTransports,
    this.apartmentRentByApartment,
    this.apartmentRentByBed,
    this.apartmentDescription,
    this.apartmentImages,
    this.apartmentVideoLink,
    this.apartmentGoogleLocation,
    this.apartmentLat,
    this.apartmentLong,
    this.apartment360DLink,
    this.apartmentSharedArea,
    this.apartmentSleepingArea,
    this.apartmentElevator,
    this.apartmentType,
    this.apartmentBedRoomsNo,
    this.apartmentBathroomNo,
    this.apartmentRooms,
    this.apartmentQrCode,
    this.apartmentQrImg,
    this.apartmentStatus,
    this.apartmentSharedType,
    this.bathroomDetails,
    this.kitchenDetails,
    this.apartmentFeatures,
    this.apartmentFacilites,
    this.canMakeRequest,
    this.shareLink,
    this.availableFrom,
    this.availableTo,
    this.minStay,
    this.isWishlist = false});

  factory ApartmentDetailsApiModelV2.fromJson(Map<String, dynamic> json) =>
      ApartmentDetailsApiModelV2(
        apartmentId: json["apartment_ID"],
        apartmentCode: json["apartment_Code"],
        apartmentName: json["apartment_Name"],
        availableBeds: json["available_Beds"],
        apartmentAllBillIncluded: json["apartment_All_Bill_Included"],
        apartmentBillDescirption: json["apartment_Bill_Descirption"],
        apartmentStreetName: json["apartment_StreetName"],
        apartmentBuildingName: json["apartment_BuildingName"],
        apartmentCity: json["apartment_City"],
        apartmentArea: json["apartment_Area"],
        apartmentAreaSquare: json["apartment_Area_Square"],
        apartmentLocation: json["apartment_Location"],
        apartmentFloor: json["apartment_Floor"],
        apartmentNo: json["apartment_No"],
        apartmentManager: json["apartment_Manager"],
        apartmentOwner: json["apartment_Owner"],
        apartmentTransports: json["apartment_Transports"] == null
            ? []
            : List<ApartmentTransport>.from(json["apartment_Transports"]!
            .map((x) => ApartmentTransport.fromJson(x))),
        apartmentRentByApartment: json["apartment_RentBy_Apartment"],
        apartmentRentByBed: json["apartment_RentBy_Bed"],
        apartmentDescription: json["apartment_Description"],
        apartmentImages: json["apartment_Images"] == null
            ? []
            : List<ApartmentImages>.from(json["apartment_Images"]!
            .map((x) => ApartmentImages.fromJson(x))),
        apartmentVideoLink: json["apartment_VideoLink"],
        apartmentGoogleLocation: json["apartment_GoogleLocation"],
        apartmentLat: json["apartment_Lat"]?.toDouble(),
        apartmentLong: json["apartment_Long"]?.toDouble(),
        apartment360DLink: json["apartment_360DLink"],
        apartmentSharedArea: json["apartment_SharedArea"],
        apartmentSleepingArea: json["apartment_SleepingArea"],
        apartmentElevator: json["apartment_Elevator"],
        apartmentType: json["apartment_Type"],
        apartmentBedRoomsNo: json["apartment_BedRoomsNo"],
        apartmentBathroomNo: json["apartment_BathroomNo"],
        apartmentRooms: json["apartment_Rooms"] == null
            ? []
            : List<ApartmentRoom>.from(
            json["apartment_Rooms"]!.map((x) => ApartmentRoom.fromJson(x))),
        apartmentQrCode: json["apartment_QRCode"],
        apartmentQrImg: json["apartment_QR_Img"],
        apartmentStatus: json["apartment_Status"],
        apartmentSharedType: json["apartment_SharedType"],
        bathroomDetails: json["bathroom_Details"] == null
            ? []
            : List<BathroomDetail>.from(json["bathroom_Details"]!
            .map((x) => BathroomDetail.fromJson(x))),
        kitchenDetails: json["kitchen_Details"] == null
            ? []
            : List<String>.from(json["kitchen_Details"]!.map((x) => x)),
        apartmentFeatures: json["apartment_Features"] == null
            ? []
            : List<String>.from(json["apartment_Features"]!.map((x) => x)),
        apartmentFacilites: json["apartment_Facilites"] == null
            ? []
            : List<String>.from(json["apartment_Facilites"]!.map((x) => x)),
        canMakeRequest: json['can_Request'] as bool? ?? true,
        isWishlist: (json['is_Wish'] as bool? ?? false),
        shareLink: (json['shareLink'] as String? ?? ""),
        minStay: json["min_Stay"] ?? 1,
        availableFrom: json["available_From"] == null
            ? null
            : DateTime.parse(json["available_From"]),
        availableTo: json["available_To"] == null
            ? null
            : DateTime.parse(json["available_To"]),
      );

  bool get isApartment => apartmentType == "Apartment";

  double get apartmentPrice {
    double totalRoomPrice = 0.0;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      totalRoomPrice += apartmentRooms![x].roomPrice!;
    }
    return totalRoomPrice;
  }

  double get apartmentSecurityFees {
    double totalSecurityPrice = 0.0;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      totalSecurityPrice += apartmentRooms![x].roomSecurityFees!;
    }
    return totalSecurityPrice;
  }

  bool get isStudio {
    return apartmentType == "Studio";
  }

  double get apartmentServicesFees {
    double totalServicesPrice = 0.0;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      totalServicesPrice += apartmentRooms![x].roomServiceFees!;
    }
    return totalServicesPrice;
  }

  int get indexRoom {
    return apartmentRooms!.indexWhere((element) => element.isSelected);
  }

  int get countOfBeds {
    int count = 0;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      count += (apartmentRooms![x].bedsNo ?? 0);
    }
    return count;
  }

  int get countOfSelectedRooms {
    int count = 0;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      if (apartmentRooms![x].isSelected) {
        count += 1;
      }
    }
    return count;
  }

  double get securityDeposit {
    return apartmentRooms![0].bedSecurityDeposit ?? 0.0;
  }

  double get subTotalBedsSelected {
    double subTotal = 0;
    if (isSelectedFullApartment) {
      for (int x = 0; x < apartmentRooms!.length; x++) {
        subTotal += apartmentRooms![x].roomPrice ?? 0;
      }
    } else {
      for (int x = 0; x < apartmentRooms!.length; x++) {
        subTotal += apartmentRooms![x].totalBedsSelected;
      }
    }

    return subTotal;
  }

  double get securityDepositBedsSelectedTotal {
    double subTotal = 0;
    if (isSelectedFullApartment) {
      for (int x = 0; x < apartmentRooms!.length; x++) {
        subTotal += apartmentRooms![x].roomSecurityFees ?? 0;
      }
    } else {
      for (int x = 0; x < apartmentRooms!.length; x++) {
        subTotal += apartmentRooms![x].totalSecurityDepositBedsSelected;
      }
    }
    return subTotal;
  }

  double get serviceBedsSelectedTotal {
    double subTotal = 0;
    if (isSelectedFullApartment) {
      for (int x = 0; x < apartmentRooms!.length; x++) {
        subTotal += apartmentRooms![x].roomServiceFees ?? 0;
      }
    } else {
      for (int x = 0; x < apartmentRooms!.length; x++) {
        subTotal += apartmentRooms![x].totalServiceBedsSelected;
      }
    }

    return subTotal;
  }

  double get totalOrder {
    double total = subTotalBedsSelected +
        securityDepositBedsSelectedTotal +
        serviceBedsSelectedTotal;
    return total;
  }

  int get countOfSelectedBeds {
    int count = 0;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      count += apartmentRooms![x].countOfSelectedBed;
    }
    return count;
  }

  int get countOfAvailableRoomsBed {
    int count = 0;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      count += apartmentRooms![x].countOfAvailableBed;
    }
    return count;
  }

  int countOfAvailableRoomsBedByDate(DateTimeRange range,
      DateTimeRange contractRange) {
    int count = 0;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      count += apartmentRooms![x].countOfAvailableBedByDateRange(
          range, contractRange);
    }
    return count;
  }

  DateTime get nearestBedDate{
    DateTime? dateTime ;
    for(int x = 0 ; x<beds!.length ; x++){
      if (beds![x].bedAvailable == true) {
        dateTime = DateTime.now();
      } else {
        // If not available, find the nearest "to" date in booked dates
        var bookedDates = beds![x].bedsBookedDates!;
        if (bookedDates.isNotEmpty) {
          for (var booking in bookedDates) {
            DateTime toDate = booking.to!;
            if (dateTime == null || toDate.isBefore(dateTime)) {
              dateTime = toDate;
            }
          }
        }
      }
    }

    return dateTime?? DateTime.now();

  }

  bool get haveUnAvailableBeds {
    bool haveUnAvailableBed = false;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      if (apartmentRooms![x].haveUnAvailableBeds) {
        haveUnAvailableBed = true;
        break;
      }
    }
    return haveUnAvailableBed;
  }

  bool haveUnAvailableBedsByDateRange(DateTimeRange range,
      DateTimeRange contractRange) {
    bool haveUnAvailableBed = false;
    for (int x = 0; x < apartmentRooms!.length; x++) {
      if (apartmentRooms![x].haveUnAvailableBedsByRangeDate(
          range, contractRange)) {
        haveUnAvailableBed = true;
        break;
      }
    }
    return haveUnAvailableBed;
  }

  List<RoomBed> get getRoomBeds {
    List<RoomBed> beds = [];
    for (int x = 0; x < apartmentRooms!.length; x++) {
      for (int bedX = 0; bedX < apartmentRooms![x].roomBeds!.length; bedX++) {
        beds.add(RoomBed(
          roomName: apartmentRooms![x].roomType,
          roomId: apartmentRooms![x].roomBeds![bedX].roomId,
          bedId: apartmentRooms![x].roomBeds![bedX].bedId,
          bedQrCode: apartmentRooms![x].roomBeds![bedX].bedQrCode,
          bedQrImg: apartmentRooms![x].roomBeds![bedX].bedQrImg,
          bedNo: apartmentRooms![x].roomBeds![bedX].bedNo,
          bedAvailable: apartmentRooms![x].roomBeds![bedX].bedAvailable,
        ));
      }
    }
    return beds;
  }

  Map<String, dynamic> toJson() =>
      {
        "apartment_ID": apartmentId,
        "apartment_Code": apartmentCode,
        "apartment_Name": apartmentName,
        "apartment_All_Bill_Included": apartmentAllBillIncluded,
        "apartment_Bill_Descirption": apartmentBillDescirption,
        "apartment_StreetName": apartmentStreetName,
        "apartment_BuildingName": apartmentBuildingName,
        "apartment_City": apartmentCity,
        "apartment_Area": apartmentArea,
        "apartment_Area_Square": apartmentAreaSquare,
        "apartment_Location": apartmentLocation,
        "apartment_Floor": apartmentFloor,
        "apartment_No": apartmentNo,
        "apartment_Manager": apartmentManager,
        "apartment_Owner": apartmentOwner,
        "apartment_Transports": apartmentTransports == null
            ? []
            : List<dynamic>.from(apartmentTransports!.map((x) => x.toJson())),
        "apartment_RentBy_Apartment": apartmentRentByApartment,
        "apartment_RentBy_Bed": apartmentRentByBed,
        "apartment_Description": apartmentDescription,
        "apartment_Images": apartmentImages == null
            ? []
            : List<dynamic>.from(apartmentImages!.map((x) => x)),
        "apartment_VideoLink": apartmentVideoLink,
        "apartment_GoogleLocation": apartmentGoogleLocation,
        "apartment_Lat": apartmentLat,
        "apartment_Long": apartmentLong,
        "apartment_360DLink": apartment360DLink,
        "apartment_SharedArea": apartmentSharedArea,
        "apartment_SleepingArea": apartmentSleepingArea,
        "apartment_Elevator": apartmentElevator,
        "apartment_Type": apartmentType,
        "apartment_BedRoomsNo": apartmentBedRoomsNo,
        "apartment_BathroomNo": apartmentBathroomNo,
        "apartment_Rooms": apartmentRooms == null
            ? []
            : List<dynamic>.from(apartmentRooms!.map((x) => x.toJson())),
        "apartment_QRCode": apartmentQrCode,
        "apartment_QR_Img": apartmentQrImg,
        "apartment_Status": apartmentStatus,
        "apartment_SharedType": apartmentSharedType,
        "bathroom_Details": bathroomDetails == null
            ? []
            : List<dynamic>.from(bathroomDetails!.map((x) => x.toJson())),
        "kitchen_Details": kitchenDetails == null
            ? []
            : List<dynamic>.from(kitchenDetails!.map((x) => x)),
        "apartment_Features": apartmentFeatures == null
            ? []
            : List<dynamic>.from(apartmentFeatures!.map((x) => x)),
        "apartment_Facilites": apartmentFacilites == null
            ? []
            : List<dynamic>.from(apartmentFacilites!.map((x) => x)),
      };
}

class ApartmentTransport {
  String? transportName;
  String? transportDistance;

  ApartmentTransport({
    this.transportName,
    this.transportDistance,
  });

  factory ApartmentTransport.fromJson(Map<String, dynamic> json) =>
      ApartmentTransport(
        transportName: json["transport_Name"],
        transportDistance: json["transport_Distance"],
      );

  Map<String, dynamic> toJson() =>
      {
        "transport_Name": transportName,
        "transport_Distance": transportDistance,
      };
}

class ApartmentImages {
  String? title, url;

  ApartmentImages({
    this.title,
    this.url,
  });

  factory ApartmentImages.fromJson(Map<String, dynamic> json) =>
      ApartmentImages(
        title: json["image_Title"],
        url: json["image_Path"],
      );

  Map<String, dynamic> toJson() =>
      {
        "image_Title": title,
        "image_Path": url,
      };
}
