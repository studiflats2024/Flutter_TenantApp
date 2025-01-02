import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/my_problems/problem_api_model.dart';

class ProblemsListWrapper extends Equatable {
  final MetaModel pagingInfo;

  final List<ProblemApiModel> data;
  final bool? succeeded;
  final String? errors;
  final String? message;

  const ProblemsListWrapper({
    required this.pagingInfo,
    required this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  factory ProblemsListWrapper.fromJson(Map<String, dynamic> json) =>
      ProblemsListWrapper(
        pagingInfo: (json['totalRecords'] != null)
            ? MetaModel.fromJson(json)
            : MetaModel.getEmptyOne(),
        data: json['data'] != null
            ? (json['data'] as List<dynamic>)
                .map((e) => ProblemApiModel.fromJson(e as Map<String, dynamic>))
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
