import 'package:vivas/apis/models/city_model/city_model.dart';
import 'package:vivas/utils/format/app_date_format.dart';

class SearchModel {
  CityModel? city;
  DateTime? startDate;
  DateTime? endDate;
  int? personNumber;

  SearchModel({
    this.city,
    this.startDate,
    this.endDate,
    this.personNumber,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    if (startDate != null) {
      map.putIfAbsent("start_Date",
          () => AppDateFormat.formattingApiDate(startDate!, "en"));
    }
    if (endDate != null) {
      map.putIfAbsent(
          "end_Date", () => AppDateFormat.formattingApiDate(endDate!, "en"));
    }
    if (personNumber != null) {
      map.putIfAbsent("guest", () => personNumber);
    }

    return map;
  }

  String get searchText {
    String title = city?.name ?? "Berlin";
    if (startDate != null) {
      title =
          "$title - ${AppDateFormat.formattingOnlyYearMonth(startDate!, "en")}";
    }
    if (endDate != null) {
      title =
          "$title - ${AppDateFormat.formattingOnlyYearMonth(endDate!, "en")}";
    }
    if (personNumber != null) {
      title = "$title - $personNumber";
    }
    return title;
  }
}
