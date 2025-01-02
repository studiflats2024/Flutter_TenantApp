import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/area_model/area_model.dart';

class CityModel extends Equatable {
  final String name;
  final List<AreaModel> areasList;

  const CityModel({required this.name, required this.areasList});

  factory CityModel.fromJson(String cityName, List<String> area) => CityModel(
        name: cityName,
        areasList: area.map((e) => AreaModel(areaId: e, areaName: e)).toList(),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'areasName': areasList,
      };

  @override
  List<Object?> get props => [name, areasList];
}
