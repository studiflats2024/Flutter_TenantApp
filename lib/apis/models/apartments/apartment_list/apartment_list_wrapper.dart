import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';

import 'apartment_item_api_model.dart';

// ApartmentDetailsWrapper
class ApartmentListWrapper extends Equatable {
  final MetaModel pagingInfo;

  final List<ApartmentItemApiModel> data;
  final bool? succeeded;
  final String? errors;
  final String? message;

  const ApartmentListWrapper({
    required this.pagingInfo,
    required this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  factory ApartmentListWrapper.fromJson(Map<String, dynamic> json) =>
      ApartmentListWrapper(
        pagingInfo: (json['totalRecords'] != null)
            ? MetaModel.fromJson(json)
            : MetaModel.getEmptyOne(),
        data: json['data'] != null
            ? (json['data'] as List<dynamic>)
                .map((e) =>
                    ApartmentItemApiModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        succeeded: json['succeeded'] as bool?,
        errors: json['errors'] as String?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'pagingInfo': pagingInfo.toJson(),
        'data': data.map((e) => e.toJson()).toList(),
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

class ApartmentListWrapperV2 extends Equatable {
  final MetaModel pagingInfo;

  final List<ApartmentItemApiV2Model> data;
  final bool? succeeded;
  final String? errors;
  final String? message;

  const ApartmentListWrapperV2({
    required this.pagingInfo,
    required this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  factory ApartmentListWrapperV2.fromJson(Map<String, dynamic> json) =>
      ApartmentListWrapperV2(
        pagingInfo: (json['totalRecords'] != null)
            ? MetaModel.fromJson(json)
            : MetaModel.getEmptyOne(),
        data: json['data'] != null && json['data'][0] != null
            ? (json['data'] as List<dynamic>)
                .map((e) =>
                    ApartmentItemApiV2Model.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        succeeded: json['succeeded'] as bool?,
        errors: json['errors'] as String?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'pagingInfo': pagingInfo.toJson(),
        'data': data.map((e) => e.toJson()).toList(),
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
