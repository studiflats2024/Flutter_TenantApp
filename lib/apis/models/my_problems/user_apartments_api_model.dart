import 'package:equatable/equatable.dart';

class UserApartmentsApiModel extends Equatable {
  final String aptUUID;
  final String aptName;
  final String aptAddress;
  final String imageUrl;

  const UserApartmentsApiModel({
    required this.aptUUID,
    required this.aptAddress,
    required this.imageUrl,
    required this.aptName,
  });

  factory UserApartmentsApiModel.fromJson(Map<String, dynamic> json) =>
      UserApartmentsApiModel(
        aptUUID: json['apartment_ID'] as String,
        aptName: json['apt_Name'] as String,
        aptAddress: json['apartment_Location'] as String,
        imageUrl: json['apartment_Images'] as String,
      );

  @override
  List<Object> get props => [
        aptUUID,
        aptName,
        aptAddress,
        imageUrl,
      ];
}
