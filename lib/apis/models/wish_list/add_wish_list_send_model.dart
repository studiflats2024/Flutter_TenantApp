import 'package:equatable/equatable.dart';

class AddWishListSendModel extends Equatable {
  final String? deviceToken;
  final String aptId;

  const AddWishListSendModel({
    this.deviceToken,
    required this.aptId,
  });

  Map<String, dynamic> toJson() => {
        'apt_ID': aptId,
      };

  @override
  List<Object?> get props {
    return [
      deviceToken,
      aptId,
    ];
  }
}
