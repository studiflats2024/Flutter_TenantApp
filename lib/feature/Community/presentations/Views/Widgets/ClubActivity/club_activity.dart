import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/Data/Models/activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/category_model.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ClubActivity/club_activity_bloc.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class ClubActivity extends BaseStatelessWidget {
  ClubActivity({super.key});

  static const routeName = '/club-activity-community';

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

  int currentIndex = 0;

  List<CategoryModel> categories = [
    CategoryModel(name: "All", asset: "", withImage: false),
    CategoryModel(
        name: "Courses", asset: AppAssetPaths.videoIcon, withImage: true),
    CategoryModel(
        name: "Workshop", asset: AppAssetPaths.workshopIcon, withImage: true),
    CategoryModel(
        name: "Events",
        asset: AppAssetPaths.calenderIconOutline,
        withImage: true),
    CategoryModel(
        name: "Consultant",
        asset: AppAssetPaths.consultantIcon,
        withImage: true),
  ];

  List<ActivityModel> activities = [
    ActivityModel(
      name: "Learn German: Beginner Level",
      image: AppAssetPaths.imageMonthlyActivities,
      rate: "4.89",
      startDate: "Feb 15 ,2025",
      endDate: "Feb 25 ,2025",
      reviews: "100",
      seats: 0,
      activitiesStatus: ActivitiesType.course,
    ),
    ActivityModel(
      name: "Learn German: Beginner Level",
      image: AppAssetPaths.imageMonthlyActivities,
      rate: "4.89",
      startDate: "Feb 15 ,2025",
      endDate: "Feb 25 ,2025",
      reviews: "100",
      seats: 0,
      activitiesStatus: ActivitiesType.workshop,
    ),
    ActivityModel(
      name: "Learn German: Beginner Level",
      image: AppAssetPaths.imageMonthlyActivities,
      rate: "4.89",
      startDate: "Feb 15 ,2025",
      endDate: "Feb 25 ,2025",
      reviews: "100",
      seats: 2,
      time: "10:00 AM",
      activitiesStatus: ActivitiesType.event,
    ),
    ActivityModel(
      name: "Learn German: Beginner Level",
      image: AppAssetPaths.imageMonthlyActivities,
      rate: "4.89",
      startDate: "Sunday ,Monday ,Wednesday",
      endDate: "Feb 25 ,2025",
      reviews: "100",
      seats: 0,
      activitiesStatus: ActivitiesType.consultant,
    ),
  ];

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalizationKeys.clubActivity,
        withBackButton: true,
        centerTitle: true,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: BlocProvider(
        create: (context) => ClubActivityBloc(),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: SizeManager.sizeSp8,
            ),
            Container(
              height: 32.r,
              margin: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
              child: ListView.separated(
                shrinkWrap: true,
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return itemCategory(index, categories[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: SizeManager.sizeSp8,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeManager.sizeSp16),
              child: Column(
                children: List.generate(activities.length, (index) {
                  return itemActivity(activities[index]);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemActivity(ActivityModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorderPrimary100),
        borderRadius: BorderRadius.all(SizeManager.circularRadius10),
      ),
      margin: EdgeInsets.only(bottom: SizeManager.sizeSp16),
      padding: EdgeInsets.all(SizeManager.sizeSp8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 115.r,
                height: 87.r,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          model.image,
                        ),
                        fit: BoxFit.cover),
                    borderRadius:
                        BorderRadius.all(SizeManager.circularRadius10)),
              ),
              SizedBox(
                width: SizeManager.sizeSp16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentIndex == 0) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeManager.sizeSp15,
                        vertical: SizeManager.sizeSp6,
                      ),
                      decoration: BoxDecoration(
                          color: cardTypeColor(model.activitiesStatus),
                          borderRadius:
                              BorderRadius.all(SizeManager.circularRadius4)),
                      child: TextApp(
                        multiLang: false,
                        text: model.activitiesStatus.name.capitalize,
                        style: textTheme.bodyLarge?.copyWith(
                          color: textActivityColor(model.activitiesStatus),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp8,
                    ),
                  ],
                  SizedBox(
                    width: 170.r,
                    child: TextApp(
                      text: model.name,
                      fontSize: FontSize.fontSize12,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.textMainColor,
                    ),
                  ),
                  SizedBox(
                    height: SizeManager.sizeSp4,
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
                      TextApp(
                        text: " (${model.reviews} Review)",
                        fontSize: FontSize.fontSize12,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.textNatural700,
                      )
                    ],
                  ),
                  if (model.seats != 0) ...[
                    SizedBox(
                      height: SizeManager.sizeSp4,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: SizeManager.sizeSp4,
                          right: SizeManager.sizeSp8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: SizeManager.circularRadius2,
                          bottomLeft: SizeManager.circularRadius2,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFC1111A).withOpacity(0.5),
                            const Color(0xFFE2888D).withOpacity(0.5),
                            const Color(0xFFF1C0C2).withOpacity(0.5),
                            const Color(0xFFFDECED),
                          ],
                        ),
                      ),
                      child: TextApp(
                        text: "${model.seats} Seat Leave",
                        fontSize: FontSize.fontSize10,
                        color: AppColors.textRed,
                        lineHeight: 1.3.r,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ]
                ],
              ),
            ],
          ),
          SizedBox(
            height: SizeManager.sizeSp8,
          ),
          Container(
            height: 1.r,
            color: AppColors.cardBorderPrimary100,
          ),
          SizedBox(
            height: SizeManager.sizeSp8,
          ),
          footer(model),
          SizedBox(
            height: SizeManager.sizeSp8,
          ),
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
      default: return AppColors.cardBackgroundCourse;
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
      default: return AppColors.textCourse;
    }
  }

  Widget footer(
    ActivityModel model,
  ) {
    if (model.activitiesStatus == ActivitiesType.event) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: AppColors.cardBorderPrimary100)),
              ),
              margin: EdgeInsets.only(right: SizeManager.sizeSp8),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssetPaths.calenderIconOutline,
                    color: AppColors.colorPrimary,
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                  TextApp(
                    text:  "${model.startDate} ",
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: AppColors.textNatural700,
                  ),
                ],
              ),
            ),
          ),
          Expanded
            (
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssetPaths.timerIcon,
                  color: AppColors.colorPrimary,
                ),
                SizedBox(
                  width: SizeManager.sizeSp8,
                ),
                TextApp(
                  text:  "${model.time}",
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: AppColors.textNatural700,
                ),
              ],
            ),
          ),
        ],
      );
    } else if (model.activitiesStatus == ActivitiesType.consultant){
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
            text:  model.startDate,
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
            text:  "${model.startDate} - ${model.endDate}",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    }
  }

  Widget itemCategory(index, CategoryModel category) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(SizeManager.circularRadius10),
          border: Border.all(color: AppColors.cardBorderPrimary100),
          color: index == currentIndex
              ? AppColors.colorPrimary
              : AppColors.textWhite),
      padding: category.withImage
          ? EdgeInsets.all(SizeManager.sizeSp8)
          : EdgeInsets.symmetric(
              vertical: SizeManager.sizeSp8, horizontal: SizeManager.sizeSp16),
      child: Row(
        children: [
          if (category.withImage) ...[
            SvgPicture.asset(
              category.asset,
              fit: BoxFit.contain,
              width: SizeManager.sizeSp16,
              height: SizeManager.sizeSp16,
            ),
            SizedBox(
              width: SizeManager.sizeSp8,
            ),
          ],
          TextApp(
            text: category.name,
            fontSize: FontSize.fontSize12,
            color: index == currentIndex
                ? AppColors.textWhite
                : AppColors.textShade3,
          )
        ],
      ),
    );
  }
}
