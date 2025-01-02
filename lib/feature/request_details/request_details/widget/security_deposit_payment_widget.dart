import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/app_pages/screen/terms_conditions_screen.dart';
import 'package:vivas/feature/request_details/request_details/widget/booking_uint_info_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/select_percentage_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SecurityDepositPaymentWidget extends BaseStatelessWidget {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;
  final bool acceptTermsConditions;
  final int selectedPercentageDeposit;
  final VoidCallback? proceedClickedCallBack;
  final VoidCallback unitInfoWidgetClickedCallBack;
  final void Function(int) changeDepositCallBack;
  final void Function(bool) changeTCCallBack;

  SecurityDepositPaymentWidget({
    super.key,
    required this.apartmentRequestsApiModel,
    required this.proceedClickedCallBack,
    required this.unitInfoWidgetClickedCallBack,
    required this.changeDepositCallBack,
    required this.changeTCCallBack,
    required this.acceptTermsConditions,
    required this.selectedPercentageDeposit,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _titleWidget(),
                  SizedBox(height: 20.h),
                  BookingUintInfoWidget(
                    address: apartmentRequestsApiModel.aptAddress,
                    title: apartmentRequestsApiModel.aptName,
                    imageUrl: apartmentRequestsApiModel.thumbImg,
                    aptBedrooms: apartmentRequestsApiModel.aptBeds,
                    aptMaxGuest: apartmentRequestsApiModel.aptGuestsNo,
                    cardClickCallback: unitInfoWidgetClickedCallBack,
                  ),
                  SizedBox(height: 20.h),
                  _percentageTextWidget(),
                  SizedBox(height: 12.h),
                  SelectPercentageWidget(
                      changeDepositCallBack, selectedPercentageDeposit),
                  SizedBox(height: 20.h),
                  _afterTheLeasePeriodTextWidget(),
                  SizedBox(height: 20.h),
                  _acceptTermsConditionsWidget(context),
                ],
              ),
            ),
          ),
        ),
        SubmitButtonWidget(
            title: translate(LocalizationKeys.proceed)!,
            onClicked: proceedClickedCallBack),
      ],
    );
  }

  Widget _afterTheLeasePeriodTextWidget() {
    return Text(
      translate(LocalizationKeys
          .afterTheLeasePeriodEndsYouCanRefundYourSecurityDeposit)!,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w400,
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
                text: "${translate(LocalizationKeys.accept)} ",
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

  Widget _titleWidget() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                "${translate(LocalizationKeys.payTheSecurityDepositToConfirmYourBooking)!} ",
            style: const TextStyle(
              color: Color(0xFF1B1B2F),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: '€${apartmentRequestsApiModel.aptSecDeposit} ',
            style: const TextStyle(
              color: Color(0xFF1151B4),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: translate(LocalizationKeys.refundedAfterCheckOut)!,
            style: const TextStyle(
              color: Color(0xFF344053),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _percentageTextWidget() {
    return Text(
      translate(LocalizationKeys.percentageOfDepositPayment)!,
      style: const TextStyle(
        color: Color(0xFF1D2838),
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _termsAndConditionsClicked(BuildContext context) {
    TermsConditionsScreen.open(context);
  }
}
