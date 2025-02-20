import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/Community/Data/Models/subscription_plans_model.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanDetails/plan_details.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

class CommunitySubscription extends BaseStatefulScreenWidget {
  final List<SubscriptionPlansModel> subscriptions;

  const CommunitySubscription(this.subscriptions, {super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _CommunitySubscription();
  }
}

class _CommunitySubscription extends BaseScreenState<CommunitySubscription> {
  CarouselSliderController controller = CarouselSliderController();

  int currentIndex = 1;

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
            itemCount: widget.subscriptions.length,
            itemBuilder: (context, index, currentPage) {
              var plan = widget.subscriptions[index];
              return itemPlan(
                  index == currentIndex,
                  plan.id ?? "",
                  plan.planName ?? "",
                  plan.planType ?? "",
                  plan.planDuration ?? "",
                  plan.planFianlPrice ?? 0,
                  plan.planFeatures ?? [],
                  getAsset(plan),
                  getColor(plan));
            },
            options: CarouselOptions(
                enlargeCenterPage: true,
                initialPage: 1,
                clipBehavior: Clip.none,
                aspectRatio: 1.5,
                viewportFraction: 0.63,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                }),
          ),
          SizedBox(
            height: SizeManager.sizeSp18,
          ),
          Padding(
            padding: EdgeInsets.all(SizeManager.sizeSp8),
            child: Center(
              child: Expanded(
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
                  count: widget.subscriptions.length,
                  // count: 3,
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

  String getAsset(SubscriptionPlansModel item) {
    switch (item.planDurationInMonths!) {
      case 12:
        return AppAssetPaths.rateIcon;
      case 1:
        return AppAssetPaths.personIcon;
      default:
        return AppAssetPaths.calenderIcon2;
    }
  }

  Color getColor(SubscriptionPlansModel item) {
    switch (item.planDurationInMonths!) {
      case 12:
        return AppColors.cardBorderGold;
      case 1:
        return AppColors.cardBorderGreen;
      default:
        return AppColors.colorPrimary;
    }
  }

  itemPlan(bool isActive, id, String plan, String description, String type,
      num price, List<String> features, String icon, Color color) {
    return InkWell(
      onTap: () {
        PlanDetails.open(context, false, id, plan);
      },
      child: Container(
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
                          style:
                              textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
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
                    TextApp(
                      multiLang: false,
                      text: "/ $type",
                      fontSize: FontSize.fontSize14,
                      color: AppColors.textNatural700,
                    )
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
                              style: textTheme.bodyMedium
                                  ?.copyWith(fontSize: 12.sp),
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
      ),
    );
  }

}
