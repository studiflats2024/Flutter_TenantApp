import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class CommunityActivities extends BaseStatelessWidget {
  CommunityActivities({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeManager.sizeSp20,
        ),
        TextApp(multiLang: true, text: LocalizationKeys.monthlyActivities),
        SizedBox(
          height: SizeManager.sizeSp16,
        ),
        SizedBox(
          height: 250.r,
          child: ListView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            children: [
              itemActions(
                  asset: AppAssetPaths.imageMonthlyActivities,
                  title: "Learn German: Beginner ",
                  time: "Feb 10 2025 - Feb 20 2025",
                  seats: "3",
                  rate: 4.5,
                  type: "Course",
                  action: () {},
                  actionFavourite: () {}),
              SizedBox(width: SizeManager.sizeSp16,),
              itemActions(
                  asset: AppAssetPaths.imageMonthlyActivities,
                  title: "Learn German: Beginner Level",
                  time: "Feb 10 2025 - Feb 20 2025",
                  seats: "3",
                  rate: 4.5,
                  type: "WorkShop",
                  action: () {},
                  actionFavourite: () {})
            ],
          ),
        ),

      ],
    );
  }

  itemActions({
    required String asset,
    required String title,
    required String time,
    required String seats,
    required String type,
    required num rate,
    required Function() action,
    required Function() actionFavourite,
  }) {
    var width = 270.r;
    return GestureDetector(
      onTap: action,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x3FA1A1A1),
              blurRadius: 5,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
          color: AppColors.textWhite,
          borderRadius: BorderRadius.all(
            SizeManager.circularRadius10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 150.r,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(AppAssetPaths.imageMonthlyActivities),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: SizeManager.circularRadius10,
                      topRight: SizeManager.circularRadius10,
                    ),
                  ),
                ),
                Positioned(
                  top: 15.r,
                  left: 8.r,
                  right: 8.r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeManager.sizeSp15,
                          vertical: SizeManager.sizeSp6,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.cardBorderPrimary100,
                            borderRadius:
                            BorderRadius.all(SizeManager.circularRadius4)),
                        child: TextApp(
                          multiLang: false,
                          text: type,
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeManager.sizeSp8,
                            vertical: SizeManager.sizeSp4,
                          ),
                          decoration: const BoxDecoration(
                              color: AppColors.textWhite,
                              shape: BoxShape.circle),
                          child: SvgPicture.asset(AppAssetPaths.communityFav)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeManager.sizeSp4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeManager.sizeSp8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (2 / 3 * width),
                        child: TextApp(
                          multiLang: false,
                          text: title,
                          fontSize: 14.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppAssetPaths.rateIcon),
                          SizedBox(
                            width: SizeManager.sizeSp8,
                          ),
                          TextApp(
                            multiLang: false,
                            text: rate.toStringAsFixed(2),
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.formFieldText,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssetPaths.locationIcon,
                            color: AppColors.colorPrimary,
                          ),
                          SizedBox(
                            width: SizeManager.sizeSp8,
                          ),
                          TextApp(
                            multiLang: false,
                            text: "Mitta Berlin ",
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textNatural700,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppAssetPaths.seatIcon),
                          SizedBox(
                            width: SizeManager.sizeSp8,
                          ),
                          TextApp(
                            multiLang: false,
                            text: "$seats ${translate(LocalizationKeys.seats)}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textNatural700,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    color: AppColors.appButtonBorder,
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp4,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(AppAssetPaths.calenderIcon),
                      SizedBox(
                        width: SizeManager.sizeSp8,
                      ),
                      TextApp(
                        multiLang: false,
                        text: time,
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.formFieldHintText,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}
