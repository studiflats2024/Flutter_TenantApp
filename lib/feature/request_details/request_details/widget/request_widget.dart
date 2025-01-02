import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/feature/request_details/request_details/widget/accept_reject_offer_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/request_header_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class RequestWidget extends BaseStatelessWidget {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;
  final VoidCallback? actionClickedCallBack;
  final VoidCallback showApartmentClickedCallBack;
  final VoidCallback massageUsClickedCallBack;
  final VoidCallback checkInDetailsClickedCallBack;
  final VoidCallback? changeDateClickedCallBack;
  final VoidCallback? cancelClickedCallBack;
  final VoidCallback? acceptOfferClickedCallBack;
  final VoidCallback? rejectOfferClickedCallBack;
  final VoidCallback? changeCheckInDetails;
  final String actionBottomTitle;
  RequestWidget(
      {super.key,
      required this.apartmentRequestsApiModel,
      required this.actionBottomTitle,
      required this.actionClickedCallBack,
      required this.showApartmentClickedCallBack,
      required this.massageUsClickedCallBack,
      required this.changeDateClickedCallBack,
      required this.cancelClickedCallBack,
      required this.checkInDetailsClickedCallBack,
      required this.acceptOfferClickedCallBack,
      required this.rejectOfferClickedCallBack,
      required this.changeCheckInDetails});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              RequestHeaderWidget(
                imageUrl: apartmentRequestsApiModel.thumbImg,
                state: apartmentRequestsApiModel.requestStatus,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _titleRateWidget(apartmentRequestsApiModel.aptName),
                    SizedBox(height: 10.h),
                    _addressWidget(apartmentRequestsApiModel.aptAddress),
                    SizedBox(height: 10.h),
                    _dateWidget(apartmentRequestsApiModel.startDate,
                        apartmentRequestsApiModel.endDate),
                    SizedBox(height: 10.h),
                    const Divider(),
                    _itemClickableWidget(
                        translate(LocalizationKeys.showApartmentDetails)!,
                        showApartmentClickedCallBack),
                    const Divider(),
                    _itemClickableWidget(translate(LocalizationKeys.contactUs)!,
                        massageUsClickedCallBack),
                    if (apartmentRequestsApiModel.nextInvoiceModel != null) ...[
                      const Divider(),
                      _itemClickableWidget(
                          translate(LocalizationKeys.checkInDetails)!,
                          checkInDetailsClickedCallBack),
                    ],
                    const Divider(),
                    _itemClickableWidget(
                        translate(LocalizationKeys.changeCheckIn)!,
                        changeCheckInDetails,
                        withIcon: false,
                        blueText: true),
                    const Divider(),
                    _itemClickableWidget(
                        translate(LocalizationKeys.changeDates)!,
                        changeDateClickedCallBack,
                        withIcon: false,
                        blueText: true),
                    const Divider(),
                    _itemClickableWidget(
                        translate(LocalizationKeys.cancelBooking)!,
                        cancelClickedCallBack,
                        withIcon: false,
                        blueText: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        apartmentRequestsApiModel.isOffered &&
                apartmentRequestsApiModel.requestStatus == "Pending"
            ? AcceptRejectOfferWidget(
                acceptOfferClickedCallBack: acceptOfferClickedCallBack,
                rejectOfferClickedCallBack: rejectOfferClickedCallBack)
            : SubmitButtonWidget(
                hint: hintTextOfSubmitWidget,
                title: actionBottomTitle,
                onClicked: actionClickedCallBack),
      ],
    );
  }

  String? get hintTextOfSubmitWidget {
    if (apartmentRequestsApiModel.showPendingText) {
      return translate(
          LocalizationKeys.onceYourRequestIsApprovedYouCanContinue);
    } else if (apartmentRequestsApiModel.rejected) {
      return null;
    } else if (apartmentRequestsApiModel.isRefunded) {
      return "${translate(LocalizationKeys.refundId)!} : ${apartmentRequestsApiModel.refundID!}";
    } else if (apartmentRequestsApiModel.isWaitingRefund) {
      return translate(LocalizationKeys.theFundsWillBeRefundedWithin2To8Weeks);
    } else if (apartmentRequestsApiModel.isCheckoutSheetReady) {
      return null;
    } else if (!apartmentRequestsApiModel.isReviewd &&
        apartmentRequestsApiModel.isReadyCheck) {
      return null;
    } else if (!apartmentRequestsApiModel.isCheckoutSheetReady &&
        apartmentRequestsApiModel.isReadyCheck) {
      return translate(LocalizationKeys.preparingCheckout);
    } else {
      return null;
    }
  }

  Widget _titleRateWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF0F1728),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _addressWidget(String aptAddress) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(AppAssetPaths.unitLocationIcon),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            aptAddress,
            style: const TextStyle(
              color: Color(0xFF878787),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateWidget(DateTime checkIn, DateTime checkOut) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.checkIn)!,
                style: const TextStyle(
                  color: Color(0xFF667084),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AppDateFormat.formattingMonthDay(
                    checkIn, appLocale.locale.languageCode),
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        Container(
          width: 1,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          height: 40,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.checkOut)!,
                style: const TextStyle(
                  color: Color(0xFF667084),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AppDateFormat.formattingMonthDay(
                    checkOut, appLocale.locale.languageCode),
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF344053),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemClickableWidget(String title, VoidCallback? onTap,
      {bool withIcon = true, bool blueText = false}) {
    withIcon;
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: onTap == null
                      ? const Color(0xFF98A1B2)
                      : blueText
                          ? const Color(0xFF1151B4)
                          : const Color(0xFF1D2939),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (withIcon)
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xff1D2939),
                ),
            ],
          ),
        ));
  }
}
