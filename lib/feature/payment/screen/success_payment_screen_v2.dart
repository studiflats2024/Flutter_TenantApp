import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../bookings/screen/hand_over_screen.dart';
import '../../contract/sign_contract/screen/sign_contract_screen_v2.dart';

// ignore: must_be_immutable
class PaymentSuccessfullyScreenV2 extends BaseStatelessWidget {
  static const routeName = '/payment-successfully-screen-v2';
  static const argumentGoToSignContract = "goToSignContract";
  static const argumentBookingDetails = "bookingDetails";
  static const argumentFunctionBack = 'function-call-back';
  static const argumentFromCash = 'from-cash';

  static void open(
      BuildContext context, BookingDetailsModel bookingDetails, Function() back,fromCash,
      {bool goToSignContract = false}) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: {
      argumentGoToSignContract: goToSignContract,
      argumentBookingDetails: bookingDetails,
      argumentFromCash : fromCash,
      argumentFunctionBack: back,
    });
  }

  bool goToSignContract(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[argumentGoToSignContract] as bool;

  bool fromCashVar(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[argumentFromCash] as bool;

  BookingDetailsModel bookingDetails(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[argumentBookingDetails] as BookingDetailsModel;

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();

  PaymentSuccessfullyScreenV2({super.key});

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
                translate( fromCashVar(context) ? LocalizationKeys
                    .yourRequestHaveBeenSentOneOfOurAgentWillCallYouSoon:LocalizationKeys
                    .youPaidSuccessfully)!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 35.h),
            AppElevatedButton.withTitle(
              onPressed: () => _openNextScreen(context),
              title: _getTitle(context),
            )
          ],
        ),
      ),
    );
  }

  String _getTitle(BuildContext context) {
    return goToSignContract(context)
        ? translate(LocalizationKeys.signContractNow) ?? ""
        : translate(LocalizationKeys.signHandoverProtocols) ?? "";
  }

  void _openNextScreen(BuildContext context) {
    if (goToSignContract(context)) {
      SignContractScreenV2.open(
              context, bookingDetails(context), true, onBack(context))
          .then((value) => onBack(context));
    } else {
      HandoverProtocolsScreen.open(context, bookingDetails(context),onBack(context),
              withReplacement: true)
          .then((value) => onBack(context));
    }
    // BottomNavigationScreen.open(context, 2);
  }
}
