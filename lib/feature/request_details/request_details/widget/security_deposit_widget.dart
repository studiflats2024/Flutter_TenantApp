import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/request_details/request_details/widget/remaing_time_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SecurityDepositWidget extends BaseStatelessWidget {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;
  final VoidCallback payNowtClickedCallBack;
  SecurityDepositWidget({
    super.key,
    required this.apartmentRequestsApiModel,
    required this.payNowtClickedCallBack,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate(LocalizationKeys.securityDeposit)!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1B1B2F),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24.h),
              _titleWidget(),
              SizedBox(height: 40.h),
              RemainingTimeWidget(apartmentRequestsApiModel.expireReq),
              SizedBox(height: 24.h),
              AppElevatedButton.withTitle(
                  onPressed: payNowtClickedCallBack,
                  title: translate(LocalizationKeys.payItNow)!),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.6),
        children: [
          TextSpan(
              text: "${translate(LocalizationKeys.youHaveAlreadyCovered)} "),
          TextSpan(text: "${apartmentRequestsApiModel.coveredPercentage}% "),
          TextSpan(
              text:
                  "${translate(LocalizationKeys.ofTheSecurityDepositAndServiceFeesAmountingTo)} "),
          TextSpan(
            text: "€${apartmentRequestsApiModel.remain.toStringAsFixed(2)} ",
            style: const TextStyle(
              color: Color(0xFF1151B4),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: '.\n'),
          TextSpan(text: "${translate(LocalizationKeys.youHave)} "),
          TextSpan(text: remainingFirstText()),
          TextSpan(
            text:
                " ${translate(LocalizationKeys.toFinalizeThePaymentForTheRemainingSecurityDepositOrRiskLosingTheAmountYouHavePaid)}",
          ),
        ],
      ),
    );
  }

  String remainingFirstText() {
    Duration duration =
        apartmentRequestsApiModel.expireReq.difference(DateTime.now());
    return prettyDuration(
      duration,
      tersity: DurationTersity.hour,
      upperTersity: DurationTersity.day,
      first: true,
      locale: DurationLocale.fromLanguageCode(appLocale.locale.languageCode)!,
    );
  }
}
