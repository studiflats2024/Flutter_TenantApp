import 'details_model.dart';

abstract class BaseWrapper {
  final bool? isSuccess;
  final DetailsModel? details;

  BaseWrapper(this.isSuccess, this.details);

  BaseWrapper.fromJson(Map<String, dynamic> json)
      : isSuccess =
            json['is_success'] != null ? json['is_success'] as bool : null,
        details = json['details'] != null
            ? DetailsModel.fromJson(json['details'] as Map<String, dynamic>)
            : null;
}
