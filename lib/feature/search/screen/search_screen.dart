import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/city_model/city_model.dart';
import 'package:vivas/feature/search/model/search_model.dart';
import 'package:vivas/feature/search/widget/duration_widget.dart';
import 'package:vivas/feature/search/widget/person_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SearchScreen extends BaseStatefulWidget {
  final void Function(SearchModel searchModel) searchCallBack;
  final SearchModel? initSearchModel;

  static open(
      BuildContext context,
      void Function(SearchModel searchModel) searchCallBack,
      SearchModel? searchModel) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          initSearchModel: searchModel,
          searchCallBack: searchCallBack,
        ),
      ),
    );
  }

  const SearchScreen(
      {required this.initSearchModel, required this.searchCallBack, super.key});

  @override
  BaseState<SearchScreen> baseCreateState() => _SearchScreenState();
}

class _SearchScreenState extends BaseState<SearchScreen> {
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
    return Scaffold(
      body: Column(
        children: [
          _searchItemWidget(),
          _bottomWidget(),
        ],
      ),
    );
  }

  Expanded _searchItemWidget() {
    return Expanded(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: ExpandableTheme(
              data: const ExpandableThemeData(
                iconColor: Colors.blue,
                useInkWell: true,
              ),
              child: Column(
                children: [
                  _titleWidget(),
                  SizedBox(height: 24.h),
                  // DestinationWidget(
                  //   changeDestinationCallBack: _changeDestinationCallBack,
                  //   area: GetIt.I<SearchManger>().citiesList,
                  //   selected: searchModel.city,
                  // ),
                  SizedBox(height: 20.h),
                  DurationWidget(
                    changeStartDateCallBack: _changeStartDateCallBack,
                    changeEndDateCallBack: _changeEndDateCallBack,
                    selectedStartDate: searchModel.startDate,
                    selectedEndDate: searchModel.endDate,
                  ),
                  SizedBox(height: 20.h),
                  PersonWidget(
                      selected: searchModel.personNumber,
                      changePersonNumberCallBack: _changePersonNumberCallBack),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomWidget() {
    return Container(
      padding:
          EdgeInsets.only(top: 20.h, bottom: 30.h, right: 25.w, left: 25.w),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 40,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppElevatedButton.withTitle(
            color: const Color(0xFFEFEFEF),
            textColor: const Color(0xFF0F0F0F),
            title: translate(LocalizationKeys.cancel)!,
            onPressed: _cancelClicked,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          AppElevatedButton.withTitle(
            title: translate(LocalizationKeys.search)!,
            onPressed: _searchClicked,
          ),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      children: [
        GestureDetector(
            onTap: _closeScreen,
            child: SvgPicture.asset(AppAssetPaths.closeIcon)),
        SizedBox(width: 10.w),
        Text(
          translate(LocalizationKeys.enterDistention)!,
          style: const TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _closeScreen() {
    Navigator.of(context).pop();
  }

  void _cancelClicked() {
    _closeScreen();
  }

  void _searchClicked() {
    widget.searchCallBack(searchModel);
  }

  void _changePersonNumberCallBack(int personNumber) {
    searchModel.personNumber = personNumber;
  }

  void _changeDestinationCallBack(CityModel? destination) {
    searchModel.city = destination;
  }

  void _changeStartDateCallBack(DateTime startDate) {
    searchModel.startDate = startDate;
  }

  void _changeEndDateCallBack(DateTime endDate) {
    searchModel.endDate = endDate;
  }
}
