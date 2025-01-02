import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class PaymentSuccessfullyScreen extends BaseStatelessWidget {
  static const routeName = '/payment-successfully-screen';
  static Future<void> open(BuildContext context) async {
    await Navigator.of(context)
        .pushNamedAndRemoveUntil(routeName, (_) => false);
  }

  PaymentSuccessfullyScreen({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              translate(LocalizationKeys.thanks)!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1151B4),
                fontSize: 24,
              ),
            ),
            SizedBox(height: 15.h),
            SvgPicture.asset(AppAssetPaths.successIcon),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 10),
              child: Text(
                translate(LocalizationKeys
                    .yourRequestHaveBeenSentOneOfOurAgentWillCallYouSoon)!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 35.h),
            AppElevatedButton.withTitle(
                onPressed: () => _openHomeScreen(context),
                title: translate(LocalizationKeys.backToHomeScreen)!)
          ],
        ),
      ),
    );
  }

  void _openHomeScreen(BuildContext context) {
    BottomNavigationScreen.open(context, 2);
  }
}
