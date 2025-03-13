import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/club_activity_model.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/ActivityDetails/activity_details.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/ClubActivity/club_activity.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class CommunityClubActivities extends BaseStatelessWidget {
  CommunityClubActivities(this.clubActivityModel, {super.key});

  ClubActivityModel clubActivityModel;

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeManager.sizeSp20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextApp(multiLang: true, text: LocalizationKeys.clubActivities),
            InkWell(
              onTap: () {
                ClubActivity.open(context, false);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp8),
                child: TextApp(
                  multiLang: true,
                  text: LocalizationKeys.seeAll,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: SizeManager.sizeSp16,
        ),
        SizedBox(
          height: 250.r,
          child: ListView.separated(
            itemCount: clubActivityModel.data?.length ?? 0,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var item = clubActivityModel.data![index];
              return itemClubActivity(item);
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: SizeManager.sizeSp16,
              );
            },
          ),
        )
      ],
    );
  }

  itemClubActivity(
    ActivitiesModel activityItem,
  ) {
    var width = 270.r;
    return GestureDetector(
      onTap: () {
        ActivityDetails.open(
            AppRoute.mainNavigatorKey.currentContext!,
            false,
            false,
            ActivityDetailsSendModel(activityItem.activityId ?? "",
                activityItem.activityType ?? ActivitiesType.course));
      },
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
                    image: (activityItem.activityMedia?.isLink ?? false)
                        ? null
                        : const DecorationImage(
                            image: AssetImage(
                                AppAssetPaths.imageMonthlyActivities),
                            fit: BoxFit.cover,
                          ),
                    borderRadius: BorderRadius.only(
                      topLeft: SizeManager.circularRadius10,
                      topRight: SizeManager.circularRadius10,
                    ),
                  ),
                  child: (activityItem.activityMedia?.isLink ?? false)
                      ? ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: SizeManager.circularRadius10,
                            topRight: SizeManager.circularRadius10,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: activityItem.activityMedia!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
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
                            color: cardTypeColor(activityItem.activityType ??
                                ActivitiesType.course),
                            borderRadius:
                                BorderRadius.all(SizeManager.circularRadius4)),
                        child: TextApp(
                          multiLang: false,
                          text: activityItem.activityType?.code ?? "",
                          style: textTheme.bodyLarge?.copyWith(
                            color: textActivityColor(
                                activityItem.activityType ??
                                    ActivitiesType.course),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      // Container(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: SizeManager.sizeSp8,
                      //       vertical: SizeManager.sizeSp4,
                      //     ),
                      //     decoration: const BoxDecoration(
                      //         color: AppColors.textWhite,
                      //         shape: BoxShape.circle),
                      //     child: SvgPicture.asset(AppAssetPaths.communityFav)),
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
                          text: activityItem.activityName ?? "",
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
                            text: (activityItem.activityRating ?? 0.0)
                                .toStringAsFixed(2),
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
                          SizedBox(
                              width: (1 / 3 * width),
                              child: TextApp(
                                multiLang: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: activityItem.activityLocation ?? "",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textNatural700,
                                ),
                              )),
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
                            text:
                                "${activityItem.activitySeats} ${translate(LocalizationKeys.seats)}",
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
                      SizedBox(
                        width: 225.r,
                        child: TextApp(
                          multiLang: false,
                          text: activityItem.postponedTo ??
                              activityItem.activityDate ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.formFieldHintText,
                          ),
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

  Color cardTypeColor(
    ActivitiesType status,
  ) {
    switch (status) {
      case ActivitiesType.course:
        return AppColors.cardBackgroundCourse;
      case ActivitiesType.workshop:
        return AppColors.cardBackgroundWorkshop;
      case ActivitiesType.event:
        return AppColors.cardBackgroundEvent;
      case ActivitiesType.consultant:
        return AppColors.cardBackgroundConsultant;
      default:
        return AppColors.cardBackgroundCourse;
    }
  }

  Color textActivityColor(
    ActivitiesType status,
  ) {
    switch (status) {
      case ActivitiesType.course:
        return AppColors.textCourse;
      case ActivitiesType.workshop:
        return AppColors.textWorkshop;
      case ActivitiesType.event:
        return AppColors.textEvent;
      case ActivitiesType.consultant:
        return AppColors.textConsultant;
      default:
        return AppColors.textCourse;
    }
  }
}
