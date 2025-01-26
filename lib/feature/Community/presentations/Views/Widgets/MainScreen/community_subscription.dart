import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/Community/Data/Models/plan_model.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

class CommunitySubscription extends BaseStatefulScreenWidget {
  const CommunitySubscription({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _CommunitySubscription();
  }
}

class _CommunitySubscription extends BaseScreenState<CommunitySubscription> {
  CarouselSliderController controller = CarouselSliderController();

  int currentIndex = 1;
  List<PlanModel> plans = [
    PlanModel(
      "Monthly",
      "Ideal for quick starts",
      "Month",
      50,
      AppColors.cardBorderGreen,
      AppAssetPaths.personIcon,
      [
        "Free entry to club events",
        "12 guest passes per year",
      ],
    ),
    PlanModel(
      "Annual",
      "Enjoy exclusive access",
      "Year",
      480,
      AppColors.cardBorderGold,
      AppAssetPaths.rateIcon,
      [
        "Free entry to club events",
        "12 guest passes per year",
      ],
    ),
    PlanModel("6-Month", "Six months of value", "6-Month", 270,
        AppColors.colorPrimary, AppAssetPaths.calenderIcon2, [
      "Free entry to club events",
      "6 guest passes per year",
    ])
  ];

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Container(
      color: AppColors.textWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeManager.sizeSp20,
          ),
          TextApp(multiLang: true, text: LocalizationKeys.subscriptionPlans),
          SizedBox(
            height: SizeManager.sizeSp16,
          ),
          CarouselSlider.builder(
            itemCount: 3,
            itemBuilder: (context, index, currentPage) {
              var plan = plans[index];
              return itemPlan(
                  index == currentIndex,
                  plan.name,
                  plan.description,
                  plan.type,
                  plan.price,
                  plan.features,
                  plan.asset,
                  plan.color);
            },
            options: CarouselOptions(
                enlargeCenterPage: true,
                initialPage: 1,
                clipBehavior: Clip.none,
                aspectRatio: 1.5,
                viewportFraction: 0.6,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                }),
          ),
          SizedBox(
            height: SizeManager.sizeSp18,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(SizeManager.sizeSp8),
              child: SizedBox(
                width: 100.r,
                child: SmoothIndicator(
                  offset: currentIndex.toDouble(),
                  count: plans.length,
                  size: Size(SizeManager.sizeSp4, SizeManager.sizeSp4),
                  effect: CustomizableEffect(
                    dotDecoration: DotDecoration(
                      width: SizeManager.sizeSp22,
                      height: SizeManager.sizeSp2,
                      color: AppColors.dotsNotActive,
                      borderRadius:
                          BorderRadius.all(SizeManager.circularRadius4),
                    ),
                    activeDotDecoration: DotDecoration(
                      width: SizeManager.sizeSp22,
                      height: SizeManager.sizeSp2,
                      color: AppColors.colorPrimary,
                      borderRadius:
                          BorderRadius.all(SizeManager.circularRadius4),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  itemPlan(bool isActive, String plan, String description, String type,
      num price, List<String> features, String icon, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp4),
      padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp8),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.all(SizeManager.circularRadius10),
        border: isActive
            ? Border.all(color: AppColors.cardBorderPrimary100, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppColors.cardBorderPrimary100
                : Colors.grey.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: SizeManager.sizeSp8,
              ),
              Row(
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeManager.sizeSp4,
                        vertical: SizeManager.sizeSp8),
                    padding: EdgeInsets.all(SizeManager.sizeSp8),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(SizeManager.circularRadius10),
                      color: color.withOpacity(0.1),
                    ),
                    child: SvgPicture.asset(
                      icon,
                    ),
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(multiLang: false, text: plan),
                      SizedBox(
                        height: SizeManager.sizeSp10,
                      ),
                      TextApp(
                        multiLang: false,
                        text: description,
                        style: textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: SizeManager.sizeSp10,
              ),
              Row(
                children: [
                  TextApp(
                    multiLang: false,
                    text: "$price € ",
                    style: textTheme.headlineLarge?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  TextApp(multiLang: false, text: "/ $type")
                ],
              ),
              SizedBox(
                height: SizeManager.sizeSp10,
              ),
              Column(
                children: List.generate(
                  features.length,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.all(SizeManager.sizeSp4),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppAssetPaths.featureIcon,
                          ),
                          SizedBox(
                            width: SizeManager.sizeSp4,
                          ),
                          TextApp(
                            multiLang: false,
                            text: features[index],
                            style:
                                textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          Positioned(
            right: SizeManager.sizeSp4,
            bottom: SizeManager.sizeSp10,
            child: const CircleAvatar(
              backgroundColor: AppColors.colorPrimary,
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textWhite,
              ),
            ),
          )
        ],
      ),
    );
  }
}
