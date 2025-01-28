import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/Data/Models/activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/day_model.dart';
import 'package:vivas/feature/Community/Data/Models/session_model.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore: must_be_immutable
class ActivityDetailsSections extends BaseStatelessWidget {
  ActivitiesType activitiesType;

  ActivityDetailsSections(this.activitiesType, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return section;
  }

  List<SessionModel> sessions = [
    SessionModel(
      title: "Learning the alphabet",
      date: "Feb 15 , 2025",
      startTime: "10:00 AM",
      endTime: "12:00 PM",
    ),
    SessionModel(
        title: "Learning the alphabet",
        date: "Feb 15 , 2025",
        startTime: "10:00 AM",
        endTime: "12:00 PM",
        video: "https://www.video.com"),
    SessionModel(
      title: "Learning the alphabet",
      date: "Feb 15 , 2025",
      startTime: "10:00 AM",
      endTime: "12:00 PM",
    ),
  ];

  List<DayModel> days = [
    DayModel("Sunday", "10:00 AM", "12:00 PM", "5"),
    DayModel("Thursday", "10:00 AM", "12:00 PM", "3"),
    DayModel("Monday", "11:00 AM", "1:00 PM", "6"),
  ];

  Widget get section {
    switch (activitiesType) {
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
                text: "Feb 15, 2025",
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
                text: "10:00 - 12:00 PM",
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
                text: "5 ${translate(LocalizationKeys.seats)}",
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
                  days.length,
                  (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeManager.sizeSp16),
                          child: TextApp(
                            text: days[index].day,
                            fontWeight: FontWeight.w400,
                            fontSize: FontSize.fontSize14,
                            color: AppColors.textMainColor,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
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
                                          "${days[index].startTime} - ${days[index].endTime}",
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
                                        "${days[index].seats} ${translate(LocalizationKeys.seats)} ",
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
                        if (index == sessions.length - 1) ...[
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
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.cardBorderPrimary100,
                  ),
                  borderRadius: BorderRadius.all(SizeManager.circularRadius10)),
              padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp8),
              child: Column(
                children: List.generate(
                  sessions.length,
                  (index) {
                    return ExpandableNotifier(
                      child: Expandable(
                        collapsed: ExpandableButton(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeManager.sizeSp16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextApp(
                                      text:
                                          "${translate(LocalizationKeys.session)} ${index + 1} - ${sessions[index].title}",
                                      fontWeight: FontWeight.w400,
                                      fontSize: FontSize.fontSize14,
                                      color: AppColors.textMainColor,
                                    ),
                                    SvgPicture.asset(AppAssetPaths.forwardIcon)
                                  ],
                                ),
                              ),
                              if (index != sessions.length - 1) ...[
                                Container(
                                  height: 1.sp,
                                  margin: EdgeInsets.symmetric(
                                      vertical: SizeManager.sizeSp4),
                                  color: AppColors.cardBorderPrimary100,
                                ),
                              ]
                            ],
                          ),
                        ),
                        expanded: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeManager.sizeSp16),
                              child: ExpandableButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextApp(
                                      text:
                                          "Session ${index + 1} - ${sessions[index].title}",
                                      fontWeight: FontWeight.w400,
                                      fontSize: FontSize.fontSize14,
                                      color: AppColors.textMainColor,
                                    ),
                                    SvgPicture.asset(
                                        AppAssetPaths.forwardIconTop)
                                  ],
                                ),
                              ),
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
                                        text: sessions[index].date,
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
                                            "${sessions[index].startTime} - ${sessions[index].endTime} ",
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
                            if (sessions[index].video != null) ...[
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AppAssetPaths.communityVideoIcon,
                                    color: AppColors.colorPrimary,
                                    width: SizeManager.sizeSp20,
                                    height: SizeManager.sizeSp20,
                                  ),
                                  SizedBox(
                                    width: SizeManager.sizeSp8,
                                  ),
                                  TextApp(
                                    text: sessions[index].video!,
                                    multiLang: false,
                                    fontWeight: FontWeight.w400,
                                    fontSize: FontSize.fontSize12,
                                    color: AppColors.colorPrimary,
                                  ),
                                ],
                              )
                            ],
                            if (index == sessions.length - 1) ...[
                              SizedBox(
                                height: SizeManager.sizeSp8,
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
    }
  }
}
