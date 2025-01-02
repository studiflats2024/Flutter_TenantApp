import 'package:equatable/equatable.dart';

class GeneralInfoApiModel extends Equatable {
  final String aptUuid;
  final String aptCode;
  final String aptName;
  final double aptPrice;
  final double aptSecurityDep;
  final bool aptAllBillsIncludes;
  final String aptBillDescription;
  final String aptStName;
  final String aptBuildingNo;
  final String aptCityOrPostal;
  final num aptLat;
  final num aptLong;
  final String aptArea;
  final String aptAddress;
  final double aptSquareMeters;
  final int aptFloorNo;
  final int aptAptNo;
  final int aptMaxGuest;
  final String aptOwner;
  final String statusString;
  final String aptStatus;
  final String aptThumbImg;
  final String aptDescription;
  final String? aptVideoLink;
  final String? apt360Link;
  final String aptTypes;
  final int aptBedrooms;
  final int aptToilets;
  final int aptLiving;
  final bool aptElevator;
  final List<String> propertyImgs;

  const GeneralInfoApiModel({
    required this.aptUuid,
    required this.aptCode,
    required this.aptName,
    required this.aptPrice,
    required this.aptSecurityDep,
    required this.aptAllBillsIncludes,
    required this.aptBillDescription,
    required this.aptStName,
    required this.aptBuildingNo,
    required this.aptCityOrPostal,
    required this.aptLat,
    required this.aptLong,
    required this.aptArea,
    required this.aptAddress,
    required this.aptSquareMeters,
    required this.aptFloorNo,
    required this.aptAptNo,
    required this.aptMaxGuest,
    required this.aptOwner,
    required this.statusString,
    required this.aptStatus,
    required this.aptThumbImg,
    required this.aptDescription,
    required this.aptVideoLink,
    required this.apt360Link,
    required this.aptTypes,
    required this.aptBedrooms,
    required this.aptToilets,
    required this.aptLiving,
    required this.aptElevator,
    required this.propertyImgs,
  });

  factory GeneralInfoApiModel.fromJson(Map<String, dynamic> json) =>
      GeneralInfoApiModel(
        aptUuid: json['apt_UUID'] as String,
        aptCode: json['apt_Code'] as String,
        aptName: json['apt_Name'] as String,
        aptPrice: json['apt_Price'] as double,
        aptSecurityDep: json['apt_SecuirtyDep'] as double,
        aptAllBillsIncludes: json['apt_AllBillsIncludes'] as bool,
        aptBillDescription: json['apt_BillDescirption'] as String,
        aptStName: json['apt_StName'] as String,
        aptBuildingNo: json['apt_BuildingNo'] as String,
        aptCityOrPostal: json['apt_CityorPostal'] as String,
        aptLat: json['apt_Lat'] as num,
        aptLong: json['apt_Long'] as num,
        aptArea: json['apt_Area'] as String,
        aptAddress: json['apt_Address'] as String,
        aptSquareMeters: json['apt_SquareMeters'] as double,
        aptFloorNo: json['apt_FloorNo'] as int,
        aptAptNo: json['apt_AptNo'] as int,
        aptMaxGuest: json['apt_MaxGuest'] as int,
        aptOwner: json['apt_Owner'] as String,
        statusString: json['statusString'] as String,
        aptStatus: json['apt_Status'] as String,
        aptThumbImg: json['apt_ThumbImg'] as String,
        aptDescription: json['apt_Descirpt'] as String,
        aptVideoLink: json['apt_VideoLink'] as String?,
        apt360Link: json['apt_360D'] as String?,
        aptTypes: json['apt_types'] as String,
        aptBedrooms: json['apt_Bedrooms'] as int,
        aptToilets: json['apt_Toilets'] as int,
        aptLiving: json['apt_Living'] as int,
        aptElevator: json['apt_Elevator'] as bool,
        propertyImgs: json['property_Imgs'] != null
            ? (json['property_Imgs'] as List<dynamic>)
                .map((e) => (e as Map<String, dynamic>)["apt_imgs"].toString())
                .toList()
            : [],
      );
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
        'apt_Lat': aptLat,
        'apt_Long': aptLong,
        'apt_Area': aptArea,
        'apt_Address': aptAddress,
        'apt_SquareMeters': aptSquareMeters,
        'apt_FloorNo': aptFloorNo,
        'apt_AptNo': aptAptNo,
        'apt_MaxGuest': aptMaxGuest,
        'apt_Owner': aptOwner,
        'statusString': statusString,
        'apt_Status': aptStatus,
        'apt_ThumbImg': aptThumbImg,
        'apt_Descirpt': aptDescription,
        'apt_VideoLink': aptVideoLink,
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
      aptCityOrPostal,
      aptLat,
      aptLong,
      aptArea,
      aptAddress,
      aptSquareMeters,
      aptFloorNo,
      aptAptNo,
      aptMaxGuest,
      aptOwner,
      statusString,
      aptStatus,
      aptThumbImg,
      aptDescription,
      aptVideoLink,
      aptTypes,
      aptBedrooms,
      aptToilets,
      aptLiving,
      aptElevator,
      propertyImgs,
    ];
  }
}
