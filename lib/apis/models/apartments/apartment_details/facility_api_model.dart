import 'package:equatable/equatable.dart';

class FacilityApiModel extends Equatable {
  final List<String> facNames;

  const FacilityApiModel({required this.facNames});

  factory FacilityApiModel.fromJson(Map<String, dynamic> json) =>
      FacilityApiModel(
        facNames: json['fac_Names'] != null
            ? (json['fac_Names'] as List<dynamic>)
                .map((e) => e["description"].toString())
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'fac_Names': facNames,
      };

  @override
  List<Object?> get props => [facNames];
}
