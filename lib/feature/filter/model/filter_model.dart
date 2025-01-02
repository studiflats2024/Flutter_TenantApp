import 'package:vivas/apis/models/area_model/area_model.dart';
import 'package:vivas/feature/filter/model/apartment_type_enum.dart';

class FilterModel {
  List<ApartmentType> selectedApartmentType = [];
  double? selectedMin;
  double? selectedMax;
  int? selectedRoomNumber;
  int? selectedBedNumber;
  List<AreaModel>? selectedAreaModel = [];

  FilterModel({
    this.selectedMin,
    this.selectedMax,
    this.selectedRoomNumber,
    this.selectedBedNumber,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (selectedApartmentType.isNotEmpty) {
      map.putIfAbsent("property_Type", () => selectedApartmentTypeApiKey);
    }
    if (selectedMin != null) {
      map.putIfAbsent("min_Price", () => selectedMin);
    }
    if (selectedMax != null) {
      map.putIfAbsent("max_Price", () => selectedMax);
    }
    if (selectedRoomNumber != null) {
      map.putIfAbsent("room_No", () => selectedRoomNumber);
    }
    if (selectedBedNumber != null) {
      map.putIfAbsent("Beds", () => selectedBedNumber);
    }
    return map;
  }

  String get selectedApartmentTypeApiKey {
    String key = "";
    for (var element in selectedApartmentType) {
      key = "${key.isEmpty ? "" : "$key,"}${element.apiKey}";
    }
    return key;
  }
}
