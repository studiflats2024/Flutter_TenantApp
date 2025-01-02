import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class ContentItemWidget extends BaseStatelessWidget {
  final String title;
  final bool titleIsLocalizationKey;
  final bool useIcon;
  final String assetPath;
  final List<String> listOfFeature;
  ContentItemWidget({
    required this.title,
    required this.assetPath,
    required this.listOfFeature,
    this.titleIsLocalizationKey = false,
    this.useIcon = true,
    super.key,
  });

  factory ContentItemWidget.specialFeatures(List<String> listOfFeature) {
    return ContentItemWidget(
      assetPath: AppAssetPaths.unitFeaturesIcon,
      title: LocalizationKeys.specialFeatures,
      titleIsLocalizationKey: true,
      listOfFeature: listOfFeature,
    );
  }

  factory ContentItemWidget.otherFacilities(List<String> listOfFeature) {
    return ContentItemWidget(
      assetPath: AppAssetPaths.unitFeaturesIcon,
      title: LocalizationKeys.otherFacilities,
      titleIsLocalizationKey: true,
      useIcon: false,
      listOfFeature: listOfFeature,
    );
  }
  factory ContentItemWidget.kitchen(List<String> listOfFeature) {
    return ContentItemWidget(
      assetPath: AppAssetPaths.unitKitchenIcon,
      title: LocalizationKeys.kitchen,
      titleIsLocalizationKey: true,
      listOfFeature: listOfFeature,
    );
  }
  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          _title(),
          SizedBox(height: 16.h),
          _listOfFeature(),
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          if (useIcon) ...[
            SvgPicture.asset(assetPath, height: 25.h, width: 25.w),
            SizedBox(width: 8.w),
          ],
          Text(
            titleIsLocalizationKey ? translate(title)! : title,
            style: const TextStyle(
              color: Color(0xFF1D2838),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listOfFeature() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listOfFeature.map((e) => _featureWidget(e)).toList());
  }

  Widget _featureWidget(String feature) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          feature,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        const Divider(),
      ],
    );
  }
}
