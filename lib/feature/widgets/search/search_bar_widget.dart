import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/filter/model/filter_model.dart';
import 'package:vivas/feature/filter/widget/filter_widget.dart';
import 'package:vivas/feature/search/model/search_model.dart';
import 'package:vivas/feature/search/screen/search_screen.dart';
import 'package:vivas/feature/search/screen/search_widget.dart';
import 'package:vivas/feature/search_result/screen/search_result_screen.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SearchBarWidget extends BaseStatelessWidget {
  final void Function(SearchModel searchModel) searchScreenClicked;
  final void Function(FilterModel) filterSearchClicked;
  final SearchModel? searchModel;
  final FilterModel? filterModel;
  final bool fromHome;

  SearchBarWidget({
    required this.searchScreenClicked,
    required this.filterSearchClicked,
    required this.fromHome,
    this.searchModel,
    this.filterModel,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      // onTap: () => _openSearchScreen(context),
      onTap: () {
        //Navigator.maybePop(context);
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            builder: (context) {
              return Container(
                height: 355.h,
                child: SearchWidget(
                    initSearchModel: searchModel,
                    searchCallBack: (searchModel) {
                      Navigator.pop(context);
                      SearchResultScreen.open(context,
                          filterModel: fromHome
                              ? FilterModel()
                              : filterModel ?? FilterModel(),
                          searchModel: searchModel,
                          withReplacement: !fromHome ? true : false);
                    }),
              );
            });
      },
      child: Container(
        height: 55.h,
        padding: EdgeInsets.all(12.h),
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
        child: Row(
          children: [
            SizedBox(width: 5.w),
            Builder(
              builder: (context) {
                return !fromHome
                    ? GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.colorPrimary,
                          ),
                        ),
                      )
                    : const EmptyWidget();
              },
            ),
            Icon(
              Icons.search,
              color: AppColors.searchItemColor,
              size: 20.r,
            ),
            SizedBox(width: 10.w),
            Text((searchModel?.searchText.isNullOrEmpty ?? true)
                ? translate(LocalizationKeys.search)!
                : searchModel!.searchText , style: TextStyle(fontSize: 14.sp),),
            const Spacer(),
            SizedBox(width: 5.w),

            Visibility(
              visible: !fromHome,
              child:  GestureDetector(
              onTap:  () => _openFlitterCallBack(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  color: const Color(0xFF1151B4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: SvgPicture.asset(AppAssetPaths.settingIcon),
              ),
            ),)

          ],
        ),
      ),
    );
  }

  void _openFlitterCallBack(BuildContext context) {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: FilterWidget(
          initFilterModel: filterModel,
          onCloseCallBack: () {},
          searchCallBack: (filterModel) {
            filterSearchClicked(filterModel);
          },
        ),
        title: translate(LocalizationKeys.filters)!);
  }

  void _openSearchScreen(BuildContext context) {
    SearchScreen.open(context, searchScreenClicked, searchModel);
  }
}
