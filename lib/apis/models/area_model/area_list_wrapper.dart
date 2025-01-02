import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/area_model/area_model.dart';

// ApartmentDetailsWrapper
class AreaListWrapper extends Equatable {
  final List<AreaModel> data;

  const AreaListWrapper({
    required this.data,
  });

  factory AreaListWrapper.fromJson(List<dynamic> json) => AreaListWrapper(
      data: (json)
          .map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toMap()).toList(),
      };

  @override
  List<Object?> get props {
    return [data];
  }
}
