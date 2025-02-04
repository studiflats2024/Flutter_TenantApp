import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Models/activity_details_model.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class ActivityDetailsSubHeader extends BaseStatelessWidget {
  ActivityDetailsModel activityDetailsModel;
  List<String> images = [
    AppAssetPaths.profileDefaultAvatar,
    AppAssetPaths.profileDefaultAvatar,
    AppAssetPaths.profileDefaultAvatar,
    AppAssetPaths.profileDefaultAvatar,
    AppAssetPaths.communityAddIcon
  ];

  ActivityDetailsSubHeader({
    required this.activityDetailsModel,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeManager.sizeSp15,
                vertical: SizeManager.sizeSp6,
              ),
              decoration: BoxDecoration(
                  color: cardTypeColor(activityDetailsModel.activityType ??
                      ActivitiesType.course),
                  borderRadius: BorderRadius.all(SizeManager.circularRadius4)),
              child: TextApp(
                multiLang: false,
                text:
                    (activityDetailsModel.activityType ?? ActivitiesType.course)
                        .code,
                style: textTheme.bodyLarge?.copyWith(
                  color: textActivityColor(activityDetailsModel.activityType ??
                      ActivitiesType.course),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(AppAssetPaths.rateIcon),
                TextApp(
                  text:"${activityDetailsModel.activityRating??0.0}",
                  fontSize: FontSize.fontSize14,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textNatural700,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: SizeManager.sizeSp12,
        ),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //   // Overlapping images
        //   SizedBox(
        //     height: 40.r,
        //     width: 200.r,
        //     child: Stack(
        //       clipBehavior: Clip.none,
        //       children: List.generate(images.length, (index) {
        //         return Positioned(
        //           left: index * SizeManager.sizeSp20, // Overlap by 20 pixels
        //           child: images[index].contains("svg")
        //               ? Container(
        //                   decoration: BoxDecoration(
        //                     shape: BoxShape.circle,
        //                     border: Border(
        //                       left: BorderSide(
        //                           color: AppColors.textWhite, width: 8.r),
        //                     ),
        //                   ),
        //                   child: CircleAvatar(
        //                     radius: SizeManager.sizeSp15, // Adjust size
        //                     backgroundColor: AppColors.colorPrimary,
        //                     child: SvgPicture.asset(images[index]),
        //                   ),
        //                 )
        //               : Container(
        //                   decoration: BoxDecoration(
        //                     shape: BoxShape.circle,
        //                     border: Border.all(
        //                       color: AppColors.textWhite,
        //                       width: 2.r,
        //                     ),
        //                   ),
        //                   child: CircleAvatar(
        //                     radius: SizeManager.sizeSp15, // Adjust size
        //                     backgroundImage: AssetImage(images[index]),
        //                   ),
        //                 ),
        //         );
        //       }),
        //     ),
        //   ),
        //   InkWell(
        //       onTap: () {},
        //       child: TextApp(
        //         text: "invite",
        //         multiLang: false,
        //         color: AppColors.colorPrimary,
        //       ))
        //   // Adjust for spacing
        //   // Invite button
        // ]),
        // SizedBox(
        //   height: SizeManager.sizeSp12,
        // ),
        TextApp(
          text: activityDetailsModel.activityName ?? "",
          overflow: TextOverflow.ellipsis,
          fontSize: FontSize.fontSize18,
        ),
      ],
    );
  }

  Color cardTypeColor(ActivitiesType status) {
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

  Color textActivityColor(ActivitiesType status) {
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
