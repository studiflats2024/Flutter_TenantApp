import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';

// ApartmentDetailsWrapper
class ApartmentRequestListWrapper extends Equatable {
  final MetaModel pagingInfo;

  final List<ApartmentRequestsApiModel> data;
  final bool? succeeded;
  final String? errors;
  final String? message;

  const ApartmentRequestListWrapper({
    required this.pagingInfo,
    required this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  factory ApartmentRequestListWrapper.fromJson(Map<String, dynamic> json) =>
      ApartmentRequestListWrapper(
        pagingInfo: (json['totalRecords'] != null)
            ? MetaModel.fromJson(json)
            : MetaModel.getEmptyOne(),
        data: json['pagedData'] != null
            ? (json['pagedData'] as List<dynamic>)
                .map((e) => ApartmentRequestsApiModel.fromJson(
                    e as Map<String, dynamic>))
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
