import 'dart:convert';

import 'package:equatable/equatable.dart';

class AreaModel extends Equatable {
  final String areaId;
  final String areaName;

  const AreaModel({required this.areaId, required this.areaName});

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        areaId: json['area_ID'] as String,
        areaName: json['area_Name'] as String,
      );

  Map<String, dynamic> toMap() => {
        'area_ID': areaId,
        'area_Name': areaName,
      };

  static String encode(List<AreaModel> areas) => json.encode(
        areas.map<Map<String, dynamic>>((area) => area.toMap()).toList(),
      );

  static List<AreaModel> decode(String carts) =>
      (json.decode(carts) as List<dynamic>)
          .map<AreaModel>((item) => AreaModel.fromJson(item))
          .toList();

  @override
  List<Object?> get props => [areaId, areaName];
}
