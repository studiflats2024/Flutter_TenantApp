import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ApartmentItemApiModel extends Equatable {
  final String aptUuid;
  final String aptCode;
  final String aptName;
  final double aptPrice;
  final double aptSecurityDep;
  final bool aptAllBillsIncludes;
  final String aptBillDescription;
  final String aptStName;
  final String aptBuildingNo;
  final String aptAddress;
  final String aptCityOrPostal;
  final String aptArea;
  final double aptSquareMeters;
  final int aptFloorNo;
  final int aptAptNo;
  final int aptMaxGuest;
  final String statusString;
  final String aptStatus;
  final String aptThumbImg;
  final String aptDescription;
  final String aptVideoLink;
  final String typeString;
  final String aptTypes;
  final int aptBedrooms;
  final int aptToilets;
  final int aptLiving;
  final int availableBeds;
  final bool aptElevator;
  final List<String> propertyImgs;
  bool isWishlist = false;
  final double rate;

  ApartmentItemApiModel({
    required this.aptUuid,
    required this.aptCode,
    required this.aptName,
    required this.aptPrice,
    required this.aptSecurityDep,
    required this.aptAllBillsIncludes,
    required this.aptAddress,
    required this.aptBillDescription,
    required this.aptStName,
    required this.aptBuildingNo,
    required this.aptCityOrPostal,
    required this.aptArea,
    required this.aptSquareMeters,
    required this.aptFloorNo,
    required this.aptAptNo,
    required this.aptMaxGuest,
    required this.statusString,
    required this.aptStatus,
    required this.aptThumbImg,
    required this.aptDescription,
    required this.aptVideoLink,
    required this.typeString,
    required this.aptTypes,
    required this.aptBedrooms,
    required this.aptToilets,
    required this.aptLiving,
    required this.aptElevator,
    required this.propertyImgs,
    required this.rate,
    required this.availableBeds,
    this.isWishlist = false,
  });

  factory ApartmentItemApiModel.fromJson(Map<String, dynamic> json) =>
      ApartmentItemApiModel(
          aptUuid: json['apt_UUID'] as String,
          aptCode: json['apt_Code'] as String? ?? "",
          aptName: json['apt_Name'] as String,
          aptPrice: json['apt_Price'] as double,
          aptSecurityDep: json['apt_SecuirtyDep'] != null
              ? json['apt_SecuirtyDep'] as double
              : 0,
          aptAllBillsIncludes: json['apt_AllBillsIncludes'] != null
              ? json['apt_AllBillsIncludes'] as bool
              : false,
          aptBillDescription: json['apt_BillDescirption'] as String? ?? "",
          aptAddress: json['apt_Address'] as String? ?? "",
          aptStName: json['apt_StName'] as String? ?? "",
          aptBuildingNo: json['apt_BuildingNo'] as String? ?? "",
          aptCityOrPostal: json['apt_CityorPostal'] as String? ?? "",
          aptArea: json['apt_Area'] as String? ?? "",
          aptSquareMeters: json['apt_SquareMeters'] != null
              ? json['apt_SquareMeters'] as double
              : 0,
          aptFloorNo:
              json['apt_FloorNo'] != null ? json['apt_FloorNo'] as int : 0,
          aptAptNo: json['apt_AptNo'] != null ? json['apt_AptNo'] as int : 0,
          aptMaxGuest:
              json['apt_MaxGuest'] != null ? json['apt_MaxGuest'] as int : 0,
          statusString: json['statusString'] as String? ?? "",
          aptStatus: json['apt_Status'] as String? ?? "",
          aptThumbImg: json['apt_ThumbImg'] as String? ?? "",
          aptDescription: json['apt_Descirpt'] as String? ?? "",
          aptVideoLink: json['apt_VideoLink'] as String? ?? "",
          typeString: json['typeString'] as String? ?? "",
          aptTypes: json['apt_types'] as String? ?? "",
          aptBedrooms:
              json['apt_Bedrooms'] != null ? json['apt_Bedrooms'] as int : 0,
          aptToilets:
              json['apt_Toilets'] != null ? json['apt_Toilets'] as int : 0,
          aptLiving: json['apt_Living'] != null ? json['apt_Living'] as int : 0,
          availableBeds: json['available_Beds'] != null ? json['available_Beds'] as int : 0,
          aptElevator: json['apt_Elevator'] != null
              ? json['apt_Elevator'] as bool
              : false,
          isWishlist: json['is_Wish'] != null ? json['is_Wish'] as bool : false,

          propertyImgs: json['property_Imgs'] != null
              ? (json['property_Imgs'] as List<dynamic>)
                  .map(
                      (e) => (e as Map<String, dynamic>)["apt_imgs"].toString())
                  .toList()
              : [],
          rate: 4.7);
  bool get isApartment => aptTypes == "Apartment";
  Map<String, dynamic> toJson() => {
        'apt_UUID': aptUuid,
        'apt_Code': aptCode,
        'apt_Name': aptName,
        'apt_Price': aptPrice,
        'apt_SecuirtyDep': aptSecurityDep,
        'apt_AllBillsIncludes': aptAllBillsIncludes,
        'apt_BillDescirption': aptBillDescription,
        'apt_StName': aptStName,
        'apt_BuildingNo': aptBuildingNo,
        'apt_CityorPostal': aptCityOrPostal,
        'apt_Area': aptArea,
        'apt_SquareMeters': aptSquareMeters,
        'apt_FloorNo': aptFloorNo,
        'apt_AptNo': aptAptNo,
        'apt_MaxGuest': aptMaxGuest,
        'statusString': statusString,
        'apt_Status': aptStatus,
        'apt_ThumbImg': aptThumbImg,
        'apt_Descirpt': aptDescription,
        'apt_VideoLink': aptVideoLink,
        'typeString': typeString,
        'apt_types': aptTypes,
        'apt_Bedrooms': aptBedrooms,
        'apt_Toilets': aptToilets,
        'apt_Living': aptLiving,
        'apt_Elevator': aptElevator,
        'property_Imgs': propertyImgs,
      };

  @override
  List<Object?> get props {
    return [
      aptUuid,
      aptCode,
      aptName,
      aptPrice,
      aptSecurityDep,
      aptAllBillsIncludes,
      aptBillDescription,
      aptStName,
      aptBuildingNo,
      aptArea,
      aptSquareMeters,
      aptFloorNo,
      aptAptNo,
      aptMaxGuest,
      statusString,
      aptStatus,
      aptThumbImg,
      aptDescription,
      aptVideoLink,
      typeString,
      aptTypes,
      aptBedrooms,
      aptToilets,
      aptLiving,
      aptElevator,
      propertyImgs,
    ];
  }
}

// ignore: must_be_immutable
class ApartmentItemApiV2Model extends Equatable {
  String? apartmentId;
  String? apartmentName;
  String? apartmentType;
  String? apartmentImage;
  String? apartmentLocation;
  String? apartmentSharedType;
  int? apartmentNoBedrooms;
  int? apartmentPersonsNo;
  int? apartmentAvailableBeds;
  double? apartmentLat;
  double? apartmentLong;
  double? apartmentPrice;
  double? apartmentAreaSquare;
  bool isWishlist;

  ApartmentItemApiV2Model(
      {this.apartmentId,
      this.apartmentName,
      this.apartmentImage,
      this.apartmentNoBedrooms,
      this.apartmentPersonsNo,
        this.apartmentAvailableBeds,
      this.apartmentPrice,
      this.apartmentAreaSquare,
      this.apartmentLocation,
      this.apartmentLat,
      this.apartmentLong,
      this.apartmentType,
      this.apartmentSharedType,
      this.isWishlist = false});

  factory ApartmentItemApiV2Model.fromJson(Map<String, dynamic> json) =>
      ApartmentItemApiV2Model(
          apartmentId: json["apartment_ID"],
          apartmentName: json["apartment_Name"],
          apartmentImage: json["apartment_Image"],
          apartmentNoBedrooms: json["apartment_No_Bedrooms"],
          apartmentPersonsNo: json["apartment_Persons_No"],
          apartmentAvailableBeds: json["available_Beds"],
          apartmentPrice: json["apartment_Price"]?.toDouble() ?? 0.0,
          apartmentAreaSquare: json["apartment_Area_Square"]?.toDouble(),
          apartmentLocation: json["apartment_Location"],
          apartmentLat: json["apartment_Lat"]?.toDouble(),
          apartmentLong: json["apartment_Long"]?.toDouble(),
          apartmentType: json["apartment_Type"],
          apartmentSharedType: json["apartment_SharedType"],
          isWishlist:
              json["is_Wish"] != null ? json["is_Wish"] as bool : false);

  Map<String, dynamic> toJson() => {
        "apartment_ID": apartmentId,
        "apartment_Name": apartmentName,
        "apartment_Image": apartmentImage,
        "apartment_No_Bedrooms": apartmentNoBedrooms,
        "apartment_Persons_No": apartmentPersonsNo,
    "available_Beds" : apartmentAvailableBeds,
        "apartment_Area_Square": apartmentAreaSquare,
        "apartment_Location": apartmentLocation,
        "apartment_Lat": apartmentLat,
        "apartment_Long": apartmentLong,
        "apartment_Type": apartmentType,
        "apartment_SharedType": apartmentSharedType,
      };

  bool get isApartment => apartmentType == "Apartment";

  @override
  List<Object?> get props => [
        apartmentId,
        apartmentName,
        apartmentImage,
        apartmentNoBedrooms,
        apartmentPersonsNo,
        apartmentAreaSquare,
        apartmentLocation,
        apartmentLat,
        apartmentLong,
        apartmentType,
        apartmentSharedType
      ];
}
