import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/city_model/city_model.dart';
import 'package:vivas/feature/filter/widget/search_multi_destination_widget.dart';
import 'package:vivas/feature/search/model/search_model.dart';
import 'package:vivas/feature/search/widget/new_person_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/feature/widgets/text_field/date_range_form_field_widget.dart';
import 'package:vivas/mangers/search_manger.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/validations/validator.dart';

class SearchWidget extends BaseStatefulWidget {
  final void Function(SearchModel searchModel) searchCallBack;
  final SearchModel? initSearchModel;

  const SearchWidget(
      {required this.initSearchModel, required this.searchCallBack, super.key});

  @override
  BaseState<SearchWidget> baseCreateState() => _SearchScreenState();
}

class _SearchScreenState extends BaseState<SearchWidget> {
  SearchModel searchModel = SearchModel();

  @override
  void initState() {
    if (widget.initSearchModel != null) {
      searchModel = widget.initSearchModel!;
    }
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12).h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.50, color: Color(0xFFD6D6D6)),
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x29202020),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: -5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _searchItemWidget(),
          //_bottomWidget(),
        ],
      ),
    );
  }

  Widget _searchItemWidget() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0.5, color: Color(0xFFD0D0DD)),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child:Row(
              children: [
                SvgPicture.asset(AppAssetPaths.unitLocationIcon , color: AppColors.suffixIcon,),
                SizedBox(width: 10.w,),
                Text(
                "Berlin",
                style:
                TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
              ),],
            )
          ),
          SizedBox(height: 10.h),
          // SearchMultiDestinationWidget(
          //     changeDestinationCallBack: _changeDestinationCallBack,
          //     cities: GetIt.I<SearchManger>().citiesList,
          //     selected: searchModel.city != null ? [searchModel.city!] : [],
          //     useMultiMode: false,
          //     withTitle: false),
          // SizedBox(height: 10.h),
          DateRangeFormFieldWidget(
            withTitle: false,
            hintText: translate(LocalizationKeys.selectDate),
            initialValue:
                searchModel.startDate != null && searchModel.endDate != null
                    ? DateTimeRange(
                        start: searchModel.startDate!,
                        end: searchModel.endDate!)
                    : null,
            onChangedDate: _changeRangeDateCallBack,
            onSaved: (DateTimeRange? newValue) {},
          ),
          SizedBox(height: 5.h),
          NewPersonWidget(
              selected: searchModel.personNumber,
              changePersonNumberCallBack: _changePersonNumberCallBack),
          SizedBox(height: 10.h),
          _bottomWidget(),
        ],
      ),
    );
  }

  Widget _bottomWidget() {
    return AppElevatedButton.withTitle(
      title: translate(LocalizationKeys.search)!,
      onPressed: _searchClicked,
    );
  }

  void _searchClicked() {
    if (searchModel.personNumber != null &&
        searchModel.startDate != null &&
        searchModel.endDate != null) {
      if (Validator.validateTimeRangeSearch(DateTimeRange(
              start: searchModel.startDate!, end: searchModel.endDate!)) ==
          null) {
        widget.searchCallBack(searchModel);
      } else {
        showFeedbackMessage(
            "Please Enter Right Range for Rent (minimum 1 Month's) ");
      }
    } else {
      showFeedbackMessage("Please Fill search data all is required");
    }
  }

  void _changePersonNumberCallBack(int personNumber) {
    searchModel.personNumber = personNumber;
  }

  void _changeDestinationCallBack(List<CityModel> cities) {
    searchModel.city = cities.first;
    GetIt.I<SearchManger>().areasList = cities.first.areasList;
  }

  void _changeRangeDateCallBack(DateTimeRange? dateRange) {
    searchModel.startDate = dateRange?.start;
    searchModel.endDate = dateRange?.end;
  }
}
