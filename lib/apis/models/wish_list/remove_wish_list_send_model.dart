import 'package:equatable/equatable.dart';

class RemoveWishListSendModel extends Equatable {
  final String? deviceToken;
  final String wishId;

  const RemoveWishListSendModel({
    this.deviceToken,
    required this.wishId,
  });

  Map<String, dynamic> toJson() => {
        'Wish_ID': wishId,
        if (deviceToken != null) 'device_Token': deviceToken,
      };

  @override
  List<Object?> get props {
    return [
      deviceToken,
      wishId,
    ];
  }
}
