import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/MyPlan/contdown_timer.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class MyPlan extends BaseStatelessWidget {
  static const routeName = '/my-plan-community';

  MyPlan({super.key});

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
  Widget baseBuild(BuildContext context) {
    return const MyPlanScreen();
  }
}

class MyPlanScreen extends BaseStatefulScreenWidget {
  const MyPlanScreen({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _MyPlanScreen();
  }
}

class _MyPlanScreen extends BaseScreenState<MyPlanScreen> {
  ExpandableController controller = ExpandableController();

  List<String> features = [
    "Access to gym and sports facilities",
    "Free entry to club events",
    "Discounts on classes and workshops",
    "10 guest passes per year",
  ];

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: AppColors.textWhite),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            AppAssetPaths.backIcon,
          ),
        ),
        title: TextApp(
          text: LocalizationKeys.myPlan,
          multiLang: true,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),

        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.textWhite,
              borderRadius: BorderRadius.all(SizeManager.circularRadius10),
              border: Border(
                top: BorderSide(color: AppColors.cardBorderBrown, width: 4.r),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3FA1A1A1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
            margin: EdgeInsets.only(top: SizeManager.sizeSp16),
            padding: EdgeInsets.all(SizeManager.sizeSp16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeManager.sizeSp4,
                          vertical: SizeManager.sizeSp8),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(SizeManager.circularRadius10),
                        color: AppColors.cardBorderBrown.withOpacity(0.1),
                      ),
                      child: SvgPicture.asset(
                        AppAssetPaths.prizeIcon,
                      ),
                    ),
                    SizedBox(
                      width: SizeManager.sizeSp12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: "Free Trial Month",
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp4,
                        ),
                        TextApp(
                          text: "Enjoy exclusive access ",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textNatural700,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeManager.sizeSp24,
                ),
                TextApp(
                  text:
                      "You are currently enjoying a free trial month of your subscription.🎉",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
                SizedBox(
                  height: SizeManager.sizeSp24,
                ),
                expandedItem,
                SizedBox(
                  height: SizeManager.sizeSp16,
                ),
                dateItem
              ],
            ),
          ),
          SizedBox(
            height: SizeManager.sizeSp24,
          ),
          SizedBox(
            height: 230.r,

            child: const CountdownTimer(),
          )
        ],
      ),
    );
  }

  Widget get expandedItem {
    return ExpandableNotifier(
      child: Expandable(
        collapsed: ExpandableButton(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Features",
                      fontWeight: FontWeight.w400,
                      color: AppColors.textNatural700,
                    ),
                    SvgPicture.asset(AppAssetPaths.forwardIcon)
                  ],
                ),
              ),
              Container(
                height: 1.sp,
                margin: EdgeInsets.symmetric(vertical: SizeManager.sizeSp4),
                color: AppColors.cardBorderPrimary100,
              ),
            ],
          ),
        ),
        expanded: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
              child: ExpandableButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Features",
                      fontWeight: FontWeight.w400,
                      color: AppColors.textNatural700,
                    ),
                    SvgPicture.asset(AppAssetPaths.forwardIconTop)
                  ],
                ),
              ),
            ),
            Column(
              children: List.generate(
                features.length,
                (index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeManager.sizeSp8),
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
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textNatural700,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 1.sp,
              margin: EdgeInsets.symmetric(vertical: SizeManager.sizeSp4),
              color: AppColors.cardBorderPrimary100,
            ),
          ],
        ),
      ),
    );
  }

  Widget get dateItem {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(color: AppColors.cardBorderPrimary100))),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssetPaths.calenderIconOutline,
                  color: AppColors.colorPrimary,
                ),
                SizedBox(
                  width: SizeManager.sizeSp12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp(
                      multiLang: true,
                      text: LocalizationKeys.startDate,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: AppColors.cardTextNatural700,
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp4,
                    ),
                    TextApp(
                      text: "1/1/2025",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMainColor,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    left: BorderSide(color: AppColors.cardBorderPrimary100))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppAssetPaths.calenderIconOutline,
                  color: AppColors.colorPrimary,
                ),
                SizedBox(
                  width: SizeManager.sizeSp12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp(
                      multiLang: true,
                      text: LocalizationKeys.renewalDate,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: AppColors.cardTextNatural700,
                    ),
                    SizedBox(
                      height: SizeManager.sizeSp4,
                    ),
                    TextApp(
                      text: "1/1/2026",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMainColor,
                    ),
                  ],
                ),
                SizedBox(
                  width: SizeManager.sizeSp16,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
