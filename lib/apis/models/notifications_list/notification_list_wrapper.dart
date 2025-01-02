import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';

import 'notification_item_api_model.dart';

// ApartmentDetailsWrapper
class NotificationListWrapper extends Equatable {
  final MetaModel pagingInfo;

  final List<NotificationItemApiModel> data;
  final bool? succeeded;
  final String? errors;
  final String? message;

  const NotificationListWrapper({
    required this.pagingInfo,
    required this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  factory NotificationListWrapper.fromJson(Map<String, dynamic> json) =>
      NotificationListWrapper(
        pagingInfo: (json['totalRecords'] != null)
            ? MetaModel.fromJson(json)
            : MetaModel.getEmptyOne(),
        data: json['data'] != null && (json['data']as List<dynamic>)[0] != null
            ? (json['data'] as List<dynamic>)
                .map((e) => NotificationItemApiModel.fromJson(
                    e as Map<String, dynamic>))
                .toList()
            : [],
        succeeded: json['succeeded'] as bool?,
        errors: json['errors'] as String?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'pagingInfo': pagingInfo.toJson(),
        'succeeded': succeeded,
        'errors': errors,
        'message': message,
      };

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
