import 'package:equatable/equatable.dart';

class BathRoomApiModel extends Equatable {
  final String bathName;
  final List<String> bathTools;

  const BathRoomApiModel({required this.bathName, required this.bathTools});

  factory BathRoomApiModel.fromJson(Map<String, dynamic> json) =>
      BathRoomApiModel(
        bathName: json['bath_Name'] as String,
        bathTools: json['bath_Tools'] != null
            ? (json['bath_Tools'] as List<dynamic>)
                .map((e) => e["tool_Name"].toString())
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'bath_Name': bathName,
        'bath_Tools': bathTools,
      };

  @override
  List<Object?> get props => [bathName, bathTools];
}
