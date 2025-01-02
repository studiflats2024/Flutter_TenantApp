import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/splash/splash_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/app_lottie.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class MaintenanceApp extends BaseStatelessWidget {
  static const routeName = '/maintenance-screen';

  static Future<void> open(BuildContext context) async {
    await Navigator.pushNamedAndRemoveUntil(
        context, routeName, (route) => false);
  }

  MaintenanceApp({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AppLottie.maintenance),
          SizedBox(
            height: 25.h,
          ),
          Text(
            "Our app in maintenance now please try again Later",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          AppElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) {
                    return SplashScreen();
                  }), (route) => false);
            },
            label: Text(
              "ReOpen App",
              style: TextStyle(
                color: AppColors.appButtonText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
