import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/app_pages/screen/terms_conditions_screen.dart';
import 'package:vivas/feature/request_details/request_details/widget/remaing_time_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class CompleteYourBookingWidget extends BaseStatelessWidget {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;
  final bool acceptTermsConditions;
  final void Function(bool) changeTCCallBack;
  final VoidCallback? payNowtClickedCallBack;
  final VoidCallback payLaterClickedCallBack;
  CompleteYourBookingWidget({
    super.key,
    required this.apartmentRequestsApiModel,
    required this.acceptTermsConditions,
    required this.changeTCCallBack,
    required this.payNowtClickedCallBack,
    required this.payLaterClickedCallBack,
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
              Text(
                translate(LocalizationKeys
                    .pleasePayTheSecurityDepositOfToCompleteTheBooking)!,
                style: const TextStyle(
                  color: Color(0xFF1B1B2F),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 32.h),
              RemainingTimeWidget(apartmentRequestsApiModel.expireReq),
              SizedBox(height: 120.h),
              AppElevatedButton.withTitle(
                  onPressed: payNowtClickedCallBack,
                  title: translate(LocalizationKeys.payItNow)!),
              SizedBox(height: 10.h),
              AppTextButton.withTitle(
                  onPressed: payLaterClickedCallBack,
                  title: translate(LocalizationKeys.payLater)!),
              SizedBox(height: 10.h),
              _acceptTermsConditionsWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _acceptTermsConditionsWidget(BuildContext context) {
    return Row(
      children: [
        ColoredBox(
          color: Colors.white,
          child: SizedBox(
            height: 20.0,
            width: 20.0,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: acceptTermsConditions,
              onChanged: (value) => changeTCCallBack(value!),
              activeColor: AppColors.colorPrimary,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${translate(LocalizationKeys.iAgreeWithOur)} ",
                style: const TextStyle(
                  color: Color(0xFF1B1B2F),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text:
                    "${translate(LocalizationKeys.terms)} ${translate(LocalizationKeys.and)} ${translate(LocalizationKeys.conditions)}.",
                style: const TextStyle(
                  color: Color(0xFF4C77AB),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _termsAndConditionsClicked(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _termsAndConditionsClicked(BuildContext context) {
    TermsConditionsScreen.open(context);
  }
}
