import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bookings/screen/selfie_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../contact_support/screen/contact_support_screen.dart';

class CongratulationsScreen extends StatelessWidget {
  static const routeName = '/congratulations-screen';

  const CongratulationsScreen({super.key});

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).pushReplacementNamed(routeName);
  }


  @override
  Widget build(BuildContext context) {
    return const CongratulationsScreenFull();
  }
}

class CongratulationsScreenFull extends BaseStatefulScreenWidget {

  const CongratulationsScreenFull({super.key});

  @override
  BaseScreenState<CongratulationsScreenFull> baseScreenCreateState() {
    return _CongratulationsScreenState();
  }
}

class _CongratulationsScreenState extends BaseScreenState<CongratulationsScreenFull> {
  TapGestureRecognizer gestureRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    gestureRecognizer.onTap = _goToContactSupport;
    super.initState();
  }

  void _goToContactSupport() async{
    await ContactSupportScreen.open(context);
  }


  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssetPaths.welcomeBackground))),
            child: Stack(
              children: [
                Positioned(
                  top: 45.h,
                  right: 10.w,
                  left: 10.w,
                  child: Column(
                    children: [
                      Container(
                        width: 360.sw,
                        height: 535.h,
                        margin:
                        EdgeInsets.only(left: 15.w, right: 15.w, top: 45.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 20.h),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Congratulations,',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              height: 257.h,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 318.w,
                                    child: Text(
                                      'Your check-in process has been successfully completed. Enjoy your stay!',
                                      style: TextStyle(
                                        color: const Color(0xFF1B1B1B),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  SizedBox(
                                    width: 306.w,
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                            'If you have any questions or need further assistance, feel free to ',
                                            style: TextStyle(
                                              color: const Color(0xFF1B1B1B),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'reach out.',
                                            recognizer: gestureRecognizer,
                                            style: TextStyle(
                                              color: Color(0xFF1151B3),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 85.h,
                  right: 0,
                  left: 0,
                  child: SubmitButtonWidget(
                    title: translate(LocalizationKeys.continuee)!,
                    onClicked: () {
                     Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                    withoutShape: true,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
