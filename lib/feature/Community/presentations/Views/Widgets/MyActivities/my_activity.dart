import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/Data/Models/activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_activity_model.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

class MyActivities extends BaseStatefulScreenWidget {
  static const routeName = '/my-activity-community';

  const MyActivities({super.key});

  static Future<void> open(
    BuildContext context,
    bool replacement,
  ) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(
        routeName,
      );
    } else {
      await Navigator.of(context).pushNamed(
        routeName,
      );
    }
  }

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _MyActivities();
  }
}

class _MyActivities extends BaseScreenState<MyActivities>
    with SingleTickerProviderStateMixin {
  List<MyActivityModel> myActivities = [
    MyActivityModel(
      image: AppAssetPaths.imageMonthlyActivities,
      name: "Build Your Winning CV",
      activitiesType: ActivitiesType.workshop,
      status: ActivityStatus.started,
      date: "Feb 15 ,2025 ",
      endDate: "Feb 25 ,2025 ",
      time: "10:00 AM",
      rate: 4.23,
    ),
    MyActivityModel(
      image: AppAssetPaths.imageMonthlyActivities,
      name: "Build Your Winning CV",
      activitiesType: ActivitiesType.course,
      status: ActivityStatus.started,
      date: "Feb 15 ,2025 ",
      endDate: "Feb 25 ,2025 ",
      time: "10:00 AM",
      rate: 4.23,
    ),
    MyActivityModel(
      image: AppAssetPaths.imageMonthlyActivities,
      name: "Build Your Winning CV",
      activitiesType: ActivitiesType.event,
      status: ActivityStatus.started,
      date: "Feb 15 ,2025 ",
      endDate: "Feb 25 ,2025 ",
      time: "10:00 AM",
      rate: 4.23,
    ),
    MyActivityModel(
      image: AppAssetPaths.imageMonthlyActivities,
      name: "Build Your Winning CV",
      activitiesType: ActivitiesType.consultant,
      status: ActivityStatus.started,
      day: "Sunday",
      date: "Feb 15 ,2025 ",
      endDate: "Feb 25 ,2025 ",
      time: "10:00 AM",
      rate: 4.23,
    ),
    MyActivityModel(
      image: AppAssetPaths.imageMonthlyActivities,
      name: "Build Your Winning CV",
      activitiesType: ActivitiesType.consultant,
      status: ActivityStatus.started,
      day: "Sunday",
      date: "Feb 15 ,2025 ",
      endDate: "Feb 25 ,2025 ",
      time: "10:00 AM",
      rate: 4.23,
    ),
    MyActivityModel(
      image: AppAssetPaths.imageMonthlyActivities,
      name: "Build Your Winning CV",
      activitiesType: ActivitiesType.event,
      status: ActivityStatus.started,
      date: "Feb 15 ,2025 ",
      endDate: "Feb 25 ,2025 ",
      time: "10:00 AM",
      rate: 4.23,
    ),
    MyActivityModel(
      image: AppAssetPaths.imageMonthlyActivities,
      name: "Build Your Winning CV",
      activitiesType: ActivitiesType.event,
      status: ActivityStatus.started,
      date: "Feb 15 ,2025 ",
      endDate: "Feb 25 ,2025 ",
      time: "10:00 AM",
      rate: 4.23,
    ),
    MyActivityModel(
      image: AppAssetPaths.imageMonthlyActivities,
      name: "Build Your Winning CV",
      activitiesType: ActivitiesType.event,
      status: ActivityStatus.started,
      date: "Feb 15 ,2025 ",
      endDate: "Feb 25 ,2025 ",
      time: "10:00 AM",
      rate: 4.23,
    ),
  ];

  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Activity",
        withBackButton: true,
        multiLan: false,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColors.cardBorderPrimary100)),
            ),
            child: TabBar(
              controller: controller,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.colorPrimary,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textNatural400,
              ),
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
              indicatorColor: AppColors.colorPrimary,
              indicator: UnderlineTabIndicator(
                  borderRadius: BorderRadius.only(
                      topLeft: SizeManager.circularRadius4,
                      topRight: SizeManager.circularRadius4),
                  borderSide: const BorderSide(
                      color: AppColors.colorPrimary, width: 2)),
              tabs: const [
                Tab(
                  child: Text("Upcoming"),
                ),
                Tab(
                  child: Text("Completed"),
                ),
                Tab(
                  child: Text("Cancelled"),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: controller, children: [
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(SizeManager.sizeSp16),
                itemBuilder: (context, index) {
                  return item(myActivities[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: SizeManager.sizeSp16,
                  );
                },
                itemCount: myActivities.length,
              ),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(SizeManager.sizeSp16),
                itemBuilder: (context, index) {
                  return item(myActivities[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: SizeManager.sizeSp16,
                  );
                },
                itemCount: myActivities.length,
              ),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(SizeManager.sizeSp16),
                itemBuilder: (context, index) {
                  return item(myActivities[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: SizeManager.sizeSp16,
                  );
                },
                itemCount: myActivities.length,
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget item(MyActivityModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.cardBorderPrimary100,
        ),
        borderRadius: BorderRadius.all(SizeManager.circularRadius10),
      ),
      child: Row(
        children: [
          Container(
            width: 105.r,
            height: 112.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: SizeManager.circularRadius10,
                  bottomLeft: SizeManager.circularRadius10),
              image: DecorationImage(
                  image: AssetImage(
                    model.image,
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(SizeManager.sizeSp8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.index.toInt() == 2?
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeManager.sizeSp15,
                          vertical: SizeManager.sizeSp8,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.cardBackgroundActivityCancelled,
                            borderRadius:
                            BorderRadius.all(SizeManager.circularRadius8)),
                        child: TextApp(
                          multiLang: true,
                          text: LocalizationKeys.cancelled,
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.textActivityCancelled,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ) :
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeManager.sizeSp15,
                          vertical: SizeManager.sizeSp8,
                        ),
                        decoration: BoxDecoration(
                            color: cardTypeColor(model.activitiesType),
                            borderRadius:
                                BorderRadius.all(SizeManager.circularRadius8)),
                        child: TextApp(
                          multiLang: false,
                          text: model.activitiesType.name.capitalize,
                          style: textTheme.bodyLarge?.copyWith(
                            color: textActivityColor(model.activitiesType),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      controller.index.toInt() == 0
                          ? PopupMenuButton(
                              constraints: BoxConstraints(minWidth: 285.r),

                              padding: EdgeInsets.zero,
                              position: PopupMenuPosition.under,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  height: SizeManager.sizeSp32,
                                  value: "un_enroll",
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextApp(
                                        multiLang: true,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        text: LocalizationKeys.unEnroll,
                                      ),
                                      SvgPicture.asset(
                                        AppAssetPaths.unEnrollIcon,

                                      )
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                    height: SizeManager.sizeSp4,
                                    child: const Divider()),
                                PopupMenuItem(
                                  value: "add_to_calender",
                                  height: SizeManager.sizeSp32,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextApp(
                                        multiLang: true,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        text: LocalizationKeys.addToCalender,
                                      ),
                                      SvgPicture.asset(
                                        AppAssetPaths.calenderIconOutline,
                                        color: AppColors.colorPrimary,
                                        width: SizeManager.sizeSp20,
                                        height: SizeManager.sizeSp20,
                                      )
                                    ],
                                  ),
                                )
                              ],
                              onSelected: (value) {},
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      SizeManager.circularRadius10)),
                              child: SvgPicture.asset(AppAssetPaths.menuIcon , fit: BoxFit.none,),
                            )
                          : controller.index.toInt() == 1
                              ? SvgPicture.asset(AppAssetPaths.editRateIcon)
                              : Container(),
                    ],
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 140.r,
                        child: TextApp(
                          text: model.name,
                          fontSize: FontSize.fontSize12,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.textMainColor,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppAssetPaths.rateIcon),
                          TextApp(
                            text: " ${model.rate}",
                            fontSize: FontSize.fontSize12,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.textNatural700,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp8,
                  ),
                  footer(model)
                ],
              ),
            ),
          )
        ],
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
    }
  }

  Widget footer(
    MyActivityModel model,
  ) {
    if (model.activitiesType == ActivitiesType.event) {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          TextApp(
            text: "${model.date} - ${model.time} ",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    } else if (model.activitiesType == ActivitiesType.consultant) {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          TextApp(
            text: "${model.day} . ${model.time} ",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          TextApp(
            text: "${model.date} - ${model.endDate} ",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    }
  }
}
