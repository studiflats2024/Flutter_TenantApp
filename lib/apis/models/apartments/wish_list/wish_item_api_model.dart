import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class WishItemApiModel extends Equatable {
  final String aptUuid;
  final String aptName;
  final double aptPrice;
  final String aptThumbImg;
  final String wishId;
  final String aptAddress;
  bool isWishlist = true;

  WishItemApiModel({
    required this.aptUuid,
    required this.aptName,
    required this.aptPrice,
    required this.aptThumbImg,
    required this.wishId,
    required this.aptAddress,
    this.isWishlist = true,
  });

  factory WishItemApiModel.fromJson(Map<String, dynamic> json) =>
      WishItemApiModel(
        aptUuid: json['apt_UUID'] as String,
        wishId: json['wish_ID'] as String? ?? "",
        aptName: json['apt_Name'] as String,
        aptPrice: json['apt_Price'] as double,
        aptThumbImg: json['apt_ThumbImg'] as String? ?? "",
        aptAddress: json['apt_Address'] as String? ?? "",
      );

  @override
  List<Object?> get props {
    return [
      aptUuid,
      aptName,
      aptPrice,
      aptThumbImg,
    ];
  }
}
