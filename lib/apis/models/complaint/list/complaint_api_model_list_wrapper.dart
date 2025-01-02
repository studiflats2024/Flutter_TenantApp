import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/complaint/list/complaint_api_model.dart';

class ComplaintApiModelListWrapper extends Equatable {
  final List<ComplaintApiModel> data;

  const ComplaintApiModelListWrapper({
    required this.data,
  });

  factory ComplaintApiModelListWrapper.fromJson(List<dynamic> json) =>
      ComplaintApiModelListWrapper(
        data: (json)
            .map((e) => ComplaintApiModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props {
    return [
      data,
    ];
  }
}
