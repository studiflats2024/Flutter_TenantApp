import 'package:equatable/equatable.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class CheckInDetailsResponse extends Equatable {
  final CheckInType checkInType;
  final String? wifiName;
  final String? wifiPassword;
  final String? doorNo;
  final String? mailboxNo;
  final String? floorNo;
  final String? aptLocation;
  final String? safeCode;
  final String? safeImg;
  final String? doorImg;
  final String? trashLoc;
  final List<String>? trashImgs;
  final List<String>? rentRules;
  // final String? address;
  final String? buildingImg;

  const CheckInDetailsResponse(
      {required this.checkInType,
      required this.wifiName,
      required this.wifiPassword,
      required this.doorNo,
      required this.mailboxNo,
      required this.floorNo,
      required this.aptLocation,
      required this.safeCode,
      required this.safeImg,
      required this.doorImg,
      required this.trashLoc,
      required this.trashImgs,
      required this.rentRules,
      required this.buildingImg,
      // required this.address,
      });

  factory CheckInDetailsResponse.fromJson(Map<String, dynamic> json) =>
      CheckInDetailsResponse(
        checkInType: CheckInType.fromApi(json['checkType'] as String),
        wifiName: json['wifi_Name'] as String?,
        wifiPassword: json['wifi_Password'] as String?,
        doorNo: (json['numof_Doors'] is int)
            ? json['numof_Doors'].toString()
            : json['numof_Doors'] as String?,
        mailboxNo:(json['mailBox_Num'] is int)
            ? json['mailBox_Num'].toString()
            : json['mailBox_Num'] as String?,
        floorNo: (json['floor_No'] is int)
            ? json['floor_No'].toString()
            : json['floor_No'] as String?,
        aptLocation: json['apt_Location'] as String?,
        safeCode: json['safe_Code'] as String?,
        safeImg: json['safe_Img'] as String?,
        doorImg: json['door_Img'] as String?,
        trashLoc: json['trash_Location'] as String?,
        trashImgs: (json['trash_Pin_Imgs'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        rentRules: (json['apt_rules'] as List<dynamic>?)
                ?.map((e) => e["rule_Desc"] as String)
                .toList() ??
            [],
        buildingImg: json['building_Img'] as String?,
        // address: json['address'] as String?,
      );


  @override
  List<Object?> get props {
    return [
      checkInType,
      wifiName,
      wifiPassword,
      doorNo,
      mailboxNo,
      floorNo,
      aptLocation,
      safeCode,
      safeImg,
      doorImg,
      trashLoc,
      trashImgs,
      rentRules,
      buildingImg,
      // address
    ];
  }
}


enum CheckInType {
  selfCheckIn,
  serviceCheckIn;

  static CheckInType fromApi(String key) {
    switch (key) {
      case "Self_Check_In":
        return selfCheckIn;
      case "Service_Check_In":
        return serviceCheckIn;
      default:
        return selfCheckIn;
    }
  }

  String get toLocaleKey {
    switch (this) {
      case selfCheckIn:
        return LocalizationKeys.selfCheckInDetails;
      case serviceCheckIn:
        return LocalizationKeys.serviceCheckInDetails;
    }
  }
}
