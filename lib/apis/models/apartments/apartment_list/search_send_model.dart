import 'package:equatable/equatable.dart';
import 'package:vivas/feature/filter/model/filter_model.dart';
import 'package:vivas/feature/search/model/search_model.dart';

class SearchSendModel extends Equatable {
  final int? pageNumber;
  final int pageSize;
  final SearchModel? searchModel;
  final FilterModel? filterModel;
  final bool useAreaFromFlitter;

  const SearchSendModel({
    this.pageNumber,
    this.searchModel,
    this.filterModel,
    this.pageSize = 10,
    required this.useAreaFromFlitter,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map = {
      'page_No': pageNumber ?? 1,
      'page_Size': pageSize,
      if (searchModel != null) ...searchModel!.toJson(),
      if (filterModel != null) ...filterModel!.toJson(),
    };

    if (filterModel?.selectedAreaModel != null) {
      if (filterModel!.selectedAreaModel!.isNotEmpty) {
        map.putIfAbsent(
            "area",
            () => filterModel!.selectedAreaModel!
                .map((e) => e.areaName)
                .toList());
      }
    }
    if (searchModel?.city != null) {
      map.putIfAbsent("city", () => "Berlin");
    }
    return map;
  }

  @override
  List<Object?> get props {
    return [
      pageNumber,
      searchModel,
      filterModel,
      pageSize,
    ];
  }
}
