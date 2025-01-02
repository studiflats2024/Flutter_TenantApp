import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PassportRequestModel extends Equatable {
  String guestName;
  String guestId;
  String bedId;

  String? passportImg;
  String? passportImgRejected;
  bool validName;
  bool validPassport;
  String? invalidReason;

  PassportRequestModel({
    required this.guestName,
    required this.guestId,
    required this.bedId,
    this.passportImg,
    this.passportImgRejected,
    this.validName = true,
    this.validPassport = true,
    this.invalidReason,
  });

  factory PassportRequestModel.fromJson(Map<String, dynamic> json) =>
      PassportRequestModel(
        guestName: json['guest_Name'] as String,
        guestId: json['guest_ID'] as String,
        bedId: json['bed_Id'] as String,
        passportImg: json['guest_Passport_Img'] as String?,
        validName: json['valid_Name'] as bool? ?? true,
        validPassport: json['valid_Passport'] as bool? ?? true,
        invalidReason: json['invalid_Reason'] as String?,
      );

  Map<String, String> toJson() => {
    'guest_ID':guestId,
    'guest_Name': guestName,
    if (passportImg != null) 'guest_Passport_Img': passportImg!,
  };

  bool get isInValidData => validPassport == false;
  bool get isInvalidPassport => validName == false;
  bool get imageUploaded => (passportImg != null) ? true : false;

  @override
  List<Object> get props => [guestName , guestId];
}
