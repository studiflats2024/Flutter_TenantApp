import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/city_model/city_model.dart';

class CityListWrapper extends Equatable {
  final List<CityModel> data;

  const CityListWrapper({
    required this.data,
  });

  factory CityListWrapper.fromJson(Map<String, dynamic> json) {
    List<CityModel> list = [];
    json.forEach((key, value) {
      list.add(CityModel.fromJson(
          key, (value as List<dynamic>).map((e) => e.toString()).toList()));
    });
    return CityListWrapper(data: list);
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toMap()).toList(),
      };

  @override
  List<Object?> get props {
    return [data];
  }
}
