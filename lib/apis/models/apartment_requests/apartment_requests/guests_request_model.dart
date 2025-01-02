import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class GuestsRequestModel extends Equatable {
  String guestName;
  String? passportImg;
  bool validName;
  bool validPassport;
  String? invalidReason;

  GuestsRequestModel({
    required this.guestName,
    this.passportImg,
    this.validName = true,
    this.validPassport = true,
    this.invalidReason,
  });

  factory GuestsRequestModel.fromJson(Map<String, dynamic> json) =>
      GuestsRequestModel(
        guestName: json['guest_Name'] as String,
        passportImg: json['passport_Img'] as String?,
        validName: json['valid_Name'] as bool? ?? true,
        validPassport: json['valid_Passport'] as bool? ?? true,
        invalidReason: json['invalid_Reason'] as String?,
      );

  Map<String, String> toJson() => {
        'guest_Name': guestName,
        if (passportImg != null) 'passport_Img': passportImg!,
      };

  bool get isInValidData => validPassport == false;
  bool get isInvalidPassport => validName == false;
  bool get imageUploaded => (passportImg != null) ? true : false;

  @override
  List<Object> get props => [guestName];
}
