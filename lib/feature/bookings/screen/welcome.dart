import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bookings/screen/selfie_screen.dart';
import 'package:vivas/feature/bookings/screen/take_image_for_profile.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../contact_support/screen/contact_support_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome-screen';
  static const argumentBookingDetails = "bookingDetailsModel";
  static const argumentFunctionBack = 'function-call-back';

  const WelcomeScreen({super.key});

  static Future<void> open(BuildContext context,
      BookingDetailsModel bookingDetailsModel, Function() onBack) async {
    await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
      argumentBookingDetails: bookingDetailsModel,
      argumentFunctionBack: onBack
    });
  }

  BookingDetailsModel bookingDetailsModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[WelcomeScreen.argumentBookingDetails] as BookingDetailsModel;

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();

  @override
  Widget build(BuildContext context) {
    return WelcomeScreenFull(
      bookingDetailsModel: bookingDetailsModel(context),
      onBack: onBack(context),
    );
  }
}

class WelcomeScreenFull extends BaseStatefulScreenWidget {
  BookingDetailsModel bookingDetailsModel;
  Function() onBack;

  WelcomeScreenFull(
      {super.key, required this.bookingDetailsModel, required this.onBack});

  @override
  BaseScreenState<WelcomeScreenFull> baseScreenCreateState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends BaseScreenState<WelcomeScreenFull> {
  TextEditingController controller = TextEditingController();
  TapGestureRecognizer gestureRecognizer = TapGestureRecognizer();
  bool showHelpMessage = false;

  @override
  void initState() {
    gestureRecognizer.onTap = _goToContactSupport;
    super.initState();
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
                              'Hello ${widget.bookingDetailsModel.guests![widget.bookingDetailsModel.guestIndex].guestName},',
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
                                      'Welcome to your new home! \nWe’re thrilled to have you with us',
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
                                    width: 318.w,
                                    child: Text(
                                      'To ensure a smooth start to your tenacy, please follow the steps to complete the check-in process.',
                                      style: TextStyle(
                                        color: const Color(0xFF1B1B1B),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  SizedBox(
                                    width: 318.w,
                                    child: Text(
                                      'Its important to complete these steps promptly as they are necessary for receiving your Anmeldung',
                                      style: TextStyle(
                                        color: const Color(0xFF1B1B1B),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
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
                      widget.bookingDetailsModel.guestNeedToUploadProfileImage
                          ? TakeSelfieScreen.open(
                                  context,
                                  widget.bookingDetailsModel,
                                  true,
                                  widget.onBack)
                              .then((value) => widget.onBack())
                          : SelfieScreen.open(
                                  context,
                                  widget.bookingDetailsModel,
                                  true,
                                  widget.onBack)
                              .then((value) => widget.onBack());
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

  void _goToContactSupport() async {
    await ContactSupportScreen.open(context);
  }
}
