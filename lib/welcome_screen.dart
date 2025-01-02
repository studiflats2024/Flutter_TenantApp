import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/app_icons.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '_core/widgets/base_stateful_screen_widget.dart';
import 'feature/bottom_navigation/screen/bottom_navigation_screen.dart';

class WelcomeAuthScreen extends BaseStatefulScreenWidget {
  static const routeName = '/welcome_auth_screen';

  static Future<void> open(BuildContext context, int index) async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
      WelcomeAuthScreen.routeName,
      (_) => false,
    );
  }

  const WelcomeAuthScreen({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends BaseScreenState<WelcomeAuthScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      _openHomeScreen();
    });
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(double.infinity, 272),
              painter: RPSCustomPainter(),
            ),
            Positioned(
                right: 0,
                left: 0,
                bottom: -40.r,
                child: SvgPicture.asset(AppIcons.circleSuccessIcon))
          ],
        ),
        SizedBox(
          height: 50.r,
        ),
        Text(
          translate(LocalizationKeys.congratulations)??"",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
        ),
        SizedBox(
          height: 10.r,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            translate(LocalizationKeys.messageSuccessSignUp) ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        const Spacer(),
        Container(
          width: 250.w,
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: AppColors.appOutlinedButtonBorder),
          ),
          margin: EdgeInsets.symmetric(vertical: 20.r),
          child: Center(
            child: TextButton(
              onPressed: () {
                _openHomeScreen();
              },
              child: Text(
                translate(LocalizationKeys.continuee) ??"",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> _openHomeScreen() async {
    BottomNavigationScreen.open(context, 0);
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(400.w, 0);
    path_0.lineTo(400.w, 239.226);
    path_0.cubicTo(400.w, 239.226, 271.719, 271.218, 194, 271.092);
    path_0.cubicTo(117.05.w, 270.967, 0, 239.226, 0, 239.226);
    path_0.lineTo(0, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff1151B3).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
