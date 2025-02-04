import 'package:expandable/expandable.dart';
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
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore: must_be_immutable
class ActivityDetailsSections extends BaseStatelessWidget {
  ActivityDetailsModel activityDetailsModel;

  ActivityDetailsSections(this.activityDetailsModel, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return section;
  }

  Widget get section {
    switch (activityDetailsModel.activityType) {
      case ActivitiesType.event:
        return Column(children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.cardBorderPrimary100,
                child: SvgPicture.asset(
                  AppAssetPaths.calenderIconOutline,
                  color: AppColors.colorPrimary,
                  width: SizeManager.sizeSp20,
                  height: SizeManager.sizeSp20,
                ),
              ),
              SizedBox(
                width: SizeManager.sizeSp8,
              ),
              TextApp(
                text: activityDetailsModel.activityDate ?? "",
                multiLang: false,
                fontWeight: FontWeight.w400,
                fontSize: FontSize.fontSize12,
              )
            ],
          ),
          SizedBox(
            height: SizeManager.sizeSp8,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.cardBorderPrimary100,
                child: SvgPicture.asset(
                  AppAssetPaths.timerIcon,
                  color: AppColors.colorPrimary,
                  width: SizeManager.sizeSp20,
                  height: SizeManager.sizeSp20,
                ),
              ),
              SizedBox(
                width: SizeManager.sizeSp8,
              ),
              TextApp(
                text: activityDetailsModel.activityTime ?? "",
                multiLang: false,
                fontWeight: FontWeight.w400,
                fontSize: FontSize.fontSize12,
              )
            ],
          ),
          SizedBox(
            height: SizeManager.sizeSp8,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.cardBorderPrimary100,
                child: SvgPicture.asset(
                  AppAssetPaths.seatIcon,
                  color: AppColors.colorPrimary,
                  width: SizeManager.sizeSp20,
                  height: SizeManager.sizeSp20,
                ),
              ),
              SizedBox(
                width: SizeManager.sizeSp8,
              ),
              TextApp(
                text:
                    "${activityDetailsModel.activitySeats ?? 0.0} ${translate(LocalizationKeys.seats)}",
                multiLang: false,
                fontWeight: FontWeight.w400,
                fontSize: FontSize.fontSize12,
              )
            ],
          ),
        ]);
      case ActivitiesType.consultant:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              multiLang: true,
              fontWeight: FontWeight.w500,
              text: LocalizationKeys.days,
              fontSize: FontSize.fontSize16,
            ),
            SizedBox(
              height: SizeManager.sizeSp8,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.cardBorderPrimary100,
                  ),
                  borderRadius: BorderRadius.all(SizeManager.circularRadius10)),
              padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp8),
              child: Column(
                children: List.generate(
                  activityDetailsModel.sessionsConsults?.length ?? 0,
                  (index) {
                    SessionsConsult? session =
                        activityDetailsModel.sessionsConsults?[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeManager.sizeSp16),
                          child: TextApp(
                            text: session?.sessionDay ?? "",
                            fontWeight: FontWeight.w400,
                            fontSize: FontSize.fontSize14,
                            color: AppColors.textMainColor,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: AppColors
                                                .cardBorderPrimary100))),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppAssetPaths.timerIcon,
                                      color: AppColors.colorPrimary,
                                      width: SizeManager.sizeSp20,
                                      height: SizeManager.sizeSp20,
                                    ),
                                    SizedBox(
                                      width: SizeManager.sizeSp8,
                                    ),
                                    TextApp(
                                      text:
                                          "${session?.sessionStartTime ?? ""} - ${session?.sessionEndTime ?? ""}",
                                      multiLang: false,
                                      fontWeight: FontWeight.w400,
                                      fontSize: FontSize.fontSize12,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppAssetPaths.seatIcon,
                                    color: AppColors.colorPrimary,
                                    width: SizeManager.sizeSp20,
                                    height: SizeManager.sizeSp20,
                                  ),
                                  SizedBox(
                                    width: SizeManager.sizeSp8,
                                  ),
                                  TextApp(
                                    text:
                                        "${session?.seessionAvailableSeats ?? 0} ${translate(LocalizationKeys.seats)} ",
                                    multiLang: false,
                                    fontWeight: FontWeight.w400,
                                    fontSize: FontSize.fontSize12,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp8,
                        ),
                        if (index ==
                            (activityDetailsModel.sessionsConsults?.length ??
                                    0) -
                                1) ...[
                          SizedBox(
                            height: SizeManager.sizeSp8,
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              multiLang: true,
              fontWeight: FontWeight.w500,
              fontSize: FontSize.fontSize16,
              text: LocalizationKeys.sessions,
            ),
            SizedBox(
              height: SizeManager.sizeSp8,
            ),
            Column(
              children: List.generate(
                activityDetailsModel.sessionsCourseWorkshop?.length ?? 0,
                (index) {
                  SessionsCourseWorkshop? session =
                      activityDetailsModel.sessionsCourseWorkshop?[index];
                  num sessionNum = (index + 1);
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.cardBorderPrimary100,
                        ),
                        borderRadius:
                            BorderRadius.all(SizeManager.circularRadius10,),),
                    margin: EdgeInsets.only(bottom: SizeManager.sizeSp16),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeManager.sizeSp16,
                        vertical: SizeManager.sizeSp8),
                    child: ExpandableNotifier(
                      child: Expandable(
                        collapsed: ExpandableButton(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            AppColors.sessionCircleColor,
                                        child: TextApp(
                                          text:
                                              "${sessionNum >= 10 ? sessionNum : "0$sessionNum"}",
                                          fontSize: FontSize.fontSize16,
                                          color: AppColors.colorPrimary,
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeManager.sizeSp8,
                                      ),
                                      TextApp(
                                        text: "${session?.sessionTitle}",
                                        fontWeight: FontWeight.w400,
                                        fontSize: FontSize.fontSize14,
                                        color: AppColors.textMainColor,
                                      ),
                                    ],
                                  ),
                                  SvgPicture.asset(AppAssetPaths.forwardIcon)
                                ],
                              ),
                            ],
                          ),
                        ),
                        expanded: Column(
                          children: [
                            ExpandableButton(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            AppColors.sessionCircleColor,
                                        child: TextApp(
                                          text:
                                              "${sessionNum >= 10 ? sessionNum : "0$sessionNum"}",
                                          fontSize: FontSize.fontSize16,
                                          color: AppColors.colorPrimary,
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeManager.sizeSp8,
                                      ),
                                      TextApp(
                                        text: "${session?.sessionTitle}",
                                        fontWeight: FontWeight.w400,
                                        fontSize: FontSize.fontSize14,
                                        color: AppColors.textMainColor,
                                      ),
                                    ],
                                  ),
                                  SvgPicture.asset(AppAssetPaths.forwardIconTop)
                                ],
                              ),
                            ),
                            Container(
                              height: 1.sp,
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeManager.sizeSp8),
                              color: AppColors.cardBorderPrimary100,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssetPaths.calenderIconOutline,
                                        color: AppColors.colorPrimary,
                                        width: SizeManager.sizeSp20,
                                        height: SizeManager.sizeSp20,
                                      ),
                                      SizedBox(
                                        width: SizeManager.sizeSp8,
                                      ),
                                      TextApp(
                                        text: session?.sessionDate == null
                                            ? ""
                                            : AppDateFormat.formattingApiDate(
                                                session!.sessionDate!, "en"),
                                        multiLang: false,
                                        fontWeight: FontWeight.w400,
                                        fontSize: FontSize.fontSize12,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssetPaths.timerIcon,
                                        color: AppColors.colorPrimary,
                                        width: SizeManager.sizeSp20,
                                        height: SizeManager.sizeSp20,
                                      ),
                                      SizedBox(
                                        width: SizeManager.sizeSp8,
                                      ),
                                      TextApp(
                                        text:
                                            "${session?.startTime ?? ""} - ${session?.endTime ?? ""}",
                                        fontWeight: FontWeight.w400,
                                        fontSize: FontSize.fontSize12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (session?.sessionLink != null &&
                                session!.sessionLink!.isLink) ...[
                              SizedBox(height: SizeManager.sizeSp8),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AppAssetPaths.playIcon,
                                    color: AppColors.colorPrimary,
                                    width: SizeManager.sizeSp20,
                                    height: SizeManager.sizeSp20,
                                  ),
                                  SizedBox(
                                    width: SizeManager.sizeSp8,
                                  ),
                                  TextApp(
                                    text: session.sessionLink ?? "" ,
                                    multiLang: false,
                                    fontWeight: FontWeight.w400,
                                    fontSize: FontSize.fontSize12,
                                  )
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
    }
  }
}
