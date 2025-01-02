import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';

import 'wish_item_api_model.dart';

// ApartmentDetailsWrapper
class WishListWrapper extends Equatable {
  final MetaModel pagingInfo;

  final List<WishItemApiModel> data;
  final bool? succeeded;
  final String? errors;
  final String? message;

  const WishListWrapper({
    required this.pagingInfo,
    required this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  factory WishListWrapper.fromJson(Map<String, dynamic> json) =>
      WishListWrapper(
        pagingInfo: (json['totalRecords'] != null)
            ? MetaModel.fromJson(json)
            : MetaModel.getEmptyOne(),
        data: json['data'] != null
            ? (json['data'] as List<dynamic>)
                .map(
                    (e) => WishItemApiModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        succeeded: json['succeeded'] as bool?,
        errors: json['errors'] as String?,
        message: json['message'] as String?,
      );

  @override
  List<Object?> get props {
    return [
      pagingInfo,
      data,
      succeeded,
      errors,
      message,
    ];
  }
}
