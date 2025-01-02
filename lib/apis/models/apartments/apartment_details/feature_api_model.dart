import 'package:equatable/equatable.dart';

class FeatureApiModel extends Equatable {
  final List<String> fetNames;

  const FeatureApiModel({required this.fetNames});

  factory FeatureApiModel.fromJson(Map<String, dynamic> json) =>
      FeatureApiModel(
        fetNames: json['fet_Names'] != null
            ? (json['fet_Names'] as List<dynamic>)
                .map((e) => e["description"].toString())
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'fet_Names': fetNames,
      };

  @override
  List<Object?> get props => [fetNames];
}
