import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/area_model/area_model.dart';
import 'package:vivas/feature/filter/model/apartment_type_enum.dart';
import 'package:vivas/feature/filter/model/filter_model.dart';
import 'package:vivas/feature/filter/widget/apartment_type_widget.dart';
import 'package:vivas/feature/filter/widget/filter_multi_destination_widget.dart';
import 'package:vivas/feature/filter/widget/rooms_beds_widget.dart';
import 'package:vivas/feature/filter/widget/select_price_range_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/mangers/search_manger.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class FilterWidget extends BaseStatefulWidget {
  final VoidCallback onCloseCallBack;
  final FilterModel? initFilterModel;
  final void Function(FilterModel filterModel) searchCallBack;

  const FilterWidget(
      {required this.onCloseCallBack,
      this.initFilterModel,
      required this.searchCallBack,
      super.key});

  @override
  BaseState<FilterWidget> baseCreateState() => _FilterWidgetState();
}

class _FilterWidgetState extends BaseState<FilterWidget> {
  FilterModel filterModel = FilterModel();
  @override
  void initState() {
    if (widget.initFilterModel != null) {
      filterModel = widget.initFilterModel!;
    }
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        ApartmentTypeWidget(
          changeSelectCallBack: _changeSelectedApartmentTypeCallBack,
          selected: filterModel.selectedApartmentType,
        ),
        SizedBox(height: 24.h),
        const Divider(),
        SizedBox(height: 24.h),
        SelectPriceRange(
          min: filterModel.selectedMin,
          max: filterModel.selectedMax,
          changeRangeCallBack: _changeRangeCallBack,
        ),
        SizedBox(height: 24.h),
        const Divider(),
        SizedBox(height: 24.h),
        FilterMultiDestinationWidget(
          changeDestinationCallBack: _changeDestinationCallBack,
          area: GetIt.I<SearchManger>().areasList,
          selected: filterModel.selectedAreaModel ?? [],
        ),
        SizedBox(height: 24.h),
        const Divider(),
        SizedBox(height: 24.h),
        RoomsAndBedsWidget(
          selectedRoom: filterModel.selectedRoomNumber,
          selectedBed: filterModel.selectedBedNumber,
          changeSelectRoomCallBack: _changeSelectRoomCallBack,
          changeSelectBedCallBack: _changeSelectBedCallBack,
        ),
        SizedBox(height: 24.h),
        const Divider(),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppElevatedButton.withTitle(
              color: const Color(0xFFEFEFEF),
              textColor: const Color(0xFF0F0F0F),
              title: translate(LocalizationKeys.cancel)!,
              onPressed: _cancelClicked,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            AppElevatedButton.withTitle(
              title: translate(LocalizationKeys.search)!,
              onPressed: _searchClicked,
            ),
          ],
        ),
        SizedBox(height: 35.h),
      ],
    );
  }

  void _changeSelectBedCallBack(int? bedNumber) {
    filterModel.selectedBedNumber = bedNumber;
  }

  void _changeSelectRoomCallBack(int? roomNumber) {
    filterModel.selectedRoomNumber = roomNumber;
  }

  void _changeRangeCallBack(double min, double max) {
    filterModel.selectedMin = min;
    filterModel.selectedMax = max;
  }

  void _changeDestinationCallBack(List<AreaModel> area) {
    filterModel.selectedAreaModel = area;
  }

  void _changeSelectedApartmentTypeCallBack(List<ApartmentType> apartmentType) {
    filterModel.selectedApartmentType = apartmentType;
  }

  void _searchClicked() {
    Navigator.of(context).pop();
    widget.searchCallBack(filterModel);
  }

  void _cancelClicked() {
    Navigator.of(context).pop();
    widget.onCloseCallBack();
  }
}
