import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanHistory/plan_history.dart';
import 'package:vivas/feature/PlanSettings/Views/cancel_plans.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore:must_be_immutable
class PlanSettings extends BaseStatelessWidget {
  static const routeName = '/plan-settings';

  PlanSettings({super.key});

  static Future<void> open(
    BuildContext context,
    bool replacement,
  ) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(routeName);
    } else {
      await Navigator.of(context).pushNamed(routeName);
    }
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalizationKeys.planSettings,
        withBackButton: true,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          _buildPlanSettingSection(
            assetPath: AppAssetPaths.communityInvoiceIcon,
            title: translate(LocalizationKeys.invoiceHistory)!,
            onActionClicked: () {
              PlanHistory.open(context);
            },
          ),
          // _buildPlanSettingSection(
          //   assetPath: AppAssetPaths.autoRenewalIcon,
          //   title: translate(LocalizationKeys.autoRenewal)!,
          //   onActionClicked: () => {},
          // ),
          _buildPlanSettingSection(
            assetPath: AppAssetPaths.cancelPlanIcon,
            title: translate(LocalizationKeys.cancelPlan)!,
            onActionClicked: () {
              CancelPlans.open(context, false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSettingSection({
    required String title,
    required String assetPath,
    required Function() onActionClicked,
  }) {
    return GestureDetector(
      onTap: onActionClicked,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.cardBorderPrimary100,
          ),
          borderRadius: BorderRadius.all(
            SizeManager.circularRadius8,
          ),
        ),
        padding: EdgeInsets.all(
          SizeManager.sizeSp16,
        ),
        margin: EdgeInsets.all(
          SizeManager.sizeSp8,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  assetPath,
                ),
                SizedBox(width: 16.h),
                Text(title,
                    style: themeData.textTheme.labelMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lisTileTitle)),
                const Spacer(),
                SvgPicture.asset(AppAssetPaths.forwardNextIcon),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
