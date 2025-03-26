import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class RequestUiModel extends Equatable {
  DateTime? startDate;
  DateTime? endDate;
  int numberOfGuests;
  String chooseWhereStay;
  bool? chooseBed;
  int? bedIndex;
  int invoiceType;
  bool isFullApartment;
  String? roomID;
  String? bedID;
  Map<int, String> nameOfGuests = {};
  Map<int, Map<String, String>> roomsId = {};
  String? role;
  String aptUUID;
  String? brokerCode;
  String? promoCode;
  String? purposeOfComingToGermany;
  String? universityName;

  RequestUiModel({
    required this.aptUUID,
    this.isFullApartment = false,
    this.bedID,
    this.roomID,
    this.chooseWhereStay = "" ,
    this.chooseBed = false ,
    this.startDate,
    this.endDate,
    this.numberOfGuests = 0,
    this.invoiceType = 0,
    this.role,
    this.brokerCode,
    this.promoCode,
    this.universityName,
    this.purposeOfComingToGermany,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        numberOfGuests,
        nameOfGuests,
        invoiceType,
        roomsId,
        role,
        brokerCode,
        purposeOfComingToGermany,
      ];
}
