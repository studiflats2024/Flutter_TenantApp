import 'package:equatable/equatable.dart';

class GetWishListSendModel extends Equatable {
  final int? pageNumber;
  final String? deviceToken;
  final int pageSize;

  const GetWishListSendModel({
    this.pageNumber,
    this.deviceToken,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber ?? 1,
        'pageSize': pageSize,
        if (deviceToken != null) 'device_Token': deviceToken,
      };

  @override
  List<Object?> get props {
    return [
      pageNumber,
      pageSize,
    ];
  }
}
