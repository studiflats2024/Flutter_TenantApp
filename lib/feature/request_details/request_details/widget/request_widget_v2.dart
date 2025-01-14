import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/booking/change_check_out_date_model.dart';
import 'package:vivas/apis/models/booking/extend_contract_model.dart';
import 'package:vivas/feature/bookings/screen/booking_details_screen.dart';
import 'package:vivas/feature/bookings/screen/extend_contract_request.dart';
import 'package:vivas/feature/bookings/widget/change_check_out_dates.dart';
import 'package:vivas/feature/bookings/widget/extend_contract.dart';
import 'package:vivas/feature/contact_support/screen/chat_screen.dart';
import 'package:vivas/feature/request_details/request_details/widget/accept_reject_offer_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/request_header_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../../apis/models/booking/booking_details_model.dart';
import '../../../../utils/feedback/feedback_message.dart';

// ignore: must_be_immutable
class RequestWidgetV2 extends BaseStatelessWidget {
  final BookingDetailsModel apartmentRequestsApiModel;
  final String status;
  final VoidCallback? actionClickedCallBack;
  final VoidCallback showApartmentClickedCallBack;
  final VoidCallback massageUsClickedCallBack;
  final VoidCallback checkInDetailsClickedCallBack;
  final VoidCallback? changeDateClickedCallBack;
  final VoidCallback? cancelClickedCallBack;
  final VoidCallback? acceptOfferClickedCallBack;
  final VoidCallback? rejectOfferClickedCallBack;
  final VoidCallback? changeCheckInDetails;
  final Function() updateData;
  final String actionBottomTitle;

  RequestWidgetV2(
      {super.key,
      required this.apartmentRequestsApiModel,
      required this.status,
      required this.actionBottomTitle,
      required this.actionClickedCallBack,
      required this.showApartmentClickedCallBack,
      required this.massageUsClickedCallBack,
      required this.changeDateClickedCallBack,
      required this.cancelClickedCallBack,
      required this.checkInDetailsClickedCallBack,
      required this.acceptOfferClickedCallBack,
      required this.rejectOfferClickedCallBack,
      required this.changeCheckInDetails,
      required this.updateData});

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
                imageUrl: apartmentRequestsApiModel.apartmentPicture ?? "",
                state: status,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _titleRateWidget(
                        apartmentRequestsApiModel.apartmentName ?? ""),
                    SizedBox(height: 10.h),
                    _addressWidget(
                        apartmentRequestsApiModel.apartmentLocation ?? "",
                        apartmentRequestsApiModel.apartmentMapLink ?? ""),
                    SizedBox(height: 10.h),
                    _dateWidget(
                        DateFormat("M/d/yyyy")
                            .parse(apartmentRequestsApiModel.checkIn ?? ""),
                        DateFormat("M/d/yyyy")
                            .parse(apartmentRequestsApiModel.checkOut ?? ""),
                        AppDateFormat.appDateFormApiParse(
                            apartmentRequestsApiModel.guests?[0].checkoutDate ??
                                apartmentRequestsApiModel.checkOut ??
                                "")),
                    SizedBox(height: 10.h),
                    const Divider(),
                    _itemClickableWidget(
                        translate(LocalizationKeys.checkInDetails)!,
                        apartmentRequestsApiModel.goToArrivingDetails
                            ? showApartmentClickedCallBack
                            : null),
                    // const Divider(),
                    // _itemClickableWidget(translate(LocalizationKeys.contactUs)!,
                    //     massageUsClickedCallBack),
                    // if (apartmentRequestsApiModel.nextInvoiceModel != null) ...[
                    //   const Divider(),
                    //   _itemClickableWidget(
                    //       translate(LocalizationKeys.checkInDetails)!,
                    //       checkInDetailsClickedCallBack),
                    // ],
                    const Divider(),
                    _itemClickableWidget(
                        translate(LocalizationKeys.bedDetails)!,
                        (apartmentRequestsApiModel.guests?.isNotEmpty ?? false)
                            ? () {
                                BookingDetailsScreen.open(
                                    context, apartmentRequestsApiModel);
                              }
                            : null,
                        withIcon: true,
                        blueText: false),
                    if (apartmentRequestsApiModel.canChangeCheckout) ...[
                      const Divider(),
                      _itemClickableWidget(
                          apartmentRequestsApiModel.haveExtend
                              ? translate(LocalizationKeys.extendRequest)!
                              : translate(LocalizationKeys.extendContract)!,
                          () {
                        extendAction(
                            context,
                            apartmentRequestsApiModel.haveExtend
                                ? translate(LocalizationKeys.extendRequest)!
                                : translate(LocalizationKeys.extendContract)!);
                      },
                          withIcon: false,
                          blueText: false,
                          withStatusIcon: true,
                          status: apartmentRequestsApiModel.haveExtend? apartmentRequestsApiModel.extendStatus: ""),
                      const Divider(),
                      _itemClickableWidget(
                          translate(LocalizationKeys.changeCheckout)!, () {
                        AppBottomSheet.openAppBottomSheet(
                            context: context,
                            child: SizedBox(
                              height: 200.h,
                              width: double.infinity,
                              child: ChangeCheckOutDates(
                                  ChangeCheckOutDateModel(
                                      apartmentRequestsApiModel.bookingId ?? "",
                                      DateFormat("M/d/yyyy").parse(
                                          apartmentRequestsApiModel.checkIn!,
                                          false),
                                      DateFormat("M/d/yyyy").parse(
                                          apartmentRequestsApiModel.checkOut!,
                                          false)),
                                  updateData),
                            ),
                            title: translate(LocalizationKeys.changeCheckout)!);
                      },
                          withIcon: true, blueText: false),
                    ],
                    const Divider(),
                    _itemClickableWidget(translate(LocalizationKeys.messageUs)!,
                        () {
                      // ContactSupportScreen.open(context);
                      _goToContactSupport(
                          apartmentRequestsApiModel.apartmentId ?? '', context);
                    }, withIcon: true, blueText: false),
                    const Divider(),
                    _itemClickableWidget(
                        translate(LocalizationKeys.changeDates)!,
                        changeDateClickedCallBack,
                        withIcon: true,
                        blueText: false),
                    const Divider(),
                    _itemClickableWidget(
                        translate(LocalizationKeys.cancelBooking)!,
                        apartmentRequestsApiModel.canCancel
                            ? cancelClickedCallBack
                            : null,
                        withIcon: true,
                        blueText: false),
                  ],
                ),
              ),
            ],
          ),
        ),
        (apartmentRequestsApiModel.isOffered ?? false) && status == "Pending"
            ? AcceptRejectOfferWidget(
                acceptOfferClickedCallBack: acceptOfferClickedCallBack,
                rejectOfferClickedCallBack: rejectOfferClickedCallBack)
            : SubmitButtonWidget(
                hint: hintTextOfSubmitWidget,
                title: actionBottomTitle,
                buttonColor: colorOfSubmitWidget,
                onClicked: actionClickedCallBack),
      ],
    );
  }

  void _goToContactSupport(String aptUUID, BuildContext context) async {
    //await ContactSupportScreen.open(context);
    await ChatScreen.open(context,
        unitUUID: aptUUID, openWithReplacement: false);
  }

  String? get hintTextOfSubmitWidget {
    if (status == "Pending") {
      return translate(
          LocalizationKeys.onceYourRequestIsApprovedYouCanContinue);
    } else {
      return null;
    }
  }

  Color? get colorOfSubmitWidget {
    if (status == "Pending") {
      return AppColors.divider;
    }else if(apartmentRequestsApiModel.extendReadyForSign ?? false){
      return null;
    } else if (DateFormat("MM/dd/yyyy")
            .parse(apartmentRequestsApiModel.checkIn ?? "")
            .isAfter(DateTime.now()) &&
        apartmentRequestsApiModel.paidSecurityDeposit &&
        apartmentRequestsApiModel.signContract &&
        apartmentRequestsApiModel.goToArrivingDetails) {
      return AppColors.divider;
    } else if (!apartmentRequestsApiModel.paidSecurityDeposit &&
        apartmentRequestsApiModel.handOverSigned &&
        apartmentRequestsApiModel.rentalRulesSigned &&
        apartmentRequestsApiModel.canResumeBookingAsMainTenant) {
      return AppColors.divider;
    } else if (apartmentRequestsApiModel.handOverSigned &&
        apartmentRequestsApiModel.rentalRulesSigned &&
        apartmentRequestsApiModel.getMonthlyInvoice != null &&
        (apartmentRequestsApiModel.getMonthlyInvoice!.isCashed ?? false) &&
        (DateFormat("MM/dd/yyyy")
                .parse(apartmentRequestsApiModel.checkIn ?? "")
                .month ==
            DateTime.now().month) &&
        apartmentRequestsApiModel.canResumeBookingAsMainTenant) {
      return AppColors.divider;
    } else if (apartmentRequestsApiModel.rentalRulesSigned &&
        !apartmentRequestsApiModel.haveMonthlyInvoice &&
        apartmentRequestsApiModel.canResumeBookingAsMainTenant) {
      return AppColors.divider;
    } else if (apartmentRequestsApiModel.passportInReview) {
      return AppColors.divider;
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

  Widget _addressWidget(String aptAddress, String mapLink) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppAssetPaths.unitLocationIcon),
            SizedBox(width: 8.w),
            SizedBox(
              width: 200.w,
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
        ),
        Row(
          children: [
            InkWell(
              onTap: () async {
                try {
                  Clipboard.setData(ClipboardData(text: aptAddress));
                } catch (e) {
                  showFeedbackMessage("$e ");
                } finally {
                  showFeedbackMessage(
                      "$aptAddress Address Copied to Clipboard");
                }
              },
              child: const Icon(
                Icons.copy,
                color: AppColors.colorPrimary,
                size: 25,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            InkWell(
              onTap: () async {
                _openMap(mapLink: mapLink);
              },
              child: const Icon(
                Icons.directions,
                color: AppColors.colorPrimary,
                size: 25,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateWidget(
      DateTime checkIn, DateTime checkOut, DateTime guestCheckOut) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        ),
        if (apartmentRequestsApiModel.canChangeCheckout) ...[
          SizedBox(
            height: 20.r,
          ),
          Text(
            "${translate(LocalizationKeys.checkoutOn)} ${AppDateFormat.formattingMonthDay(guestCheckOut, appLocale.locale.languageCode)}",
            style: TextStyle(
              color: AppColors.appFormFieldErrorIBorder,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]
      ],
    );
  }

  Widget _itemClickableWidget(String title, VoidCallback? onTap,
      {bool withIcon = true,
      bool blueText = false,
      bool withStatusIcon = false,
      String status = ''}) {
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
                      ? AppColors.formFieldHintText
                      : blueText
                          ? AppColors.colorPrimary
                          : AppColors.appFormFieldTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (withIcon)
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: onTap == null
                      ? AppColors.formFieldHintText
                      : AppColors.appFormFieldTitle,
                ),
              if (withStatusIcon)
                Row(
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        color: onTap == null
                            ? AppColors.formFieldHintText
                            : blueText
                                ? AppColors.colorPrimary
                                : AppColors.appFormFieldTitle,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: onTap == null
                          ? AppColors.formFieldHintText
                          : AppColors.appFormFieldTitle,
                    ),
                  ],
                ),
            ],
          ),
        ));
  }

  void extendAction(BuildContext context, String title) {
    if (apartmentRequestsApiModel.haveExtend) {
      AppBottomSheet.openAppBottomSheet(
          context: context,
          child: SizedBox(
            height: 130.h,
            width: double.infinity,
            child: ExtendContractRequest(
              ExtendContractModel(
                bookingId: apartmentRequestsApiModel.bookingId ?? "",
                guestId: apartmentRequestsApiModel
                        .guests?[apartmentRequestsApiModel.guestIndex]
                        .guestId ??
                    "",
                extendAccepted: apartmentRequestsApiModel.extendAccepted,
                extendContract: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex]
                    .extendContract,
                extendedTo: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex].extendedTo,
                extendedFrom: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex].extendedFrom,
                extendId: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex].extendID,
                extendSignature: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex]
                    .extendContractSignature,
                extendStatus: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex]
                    .extendingStatus,
                extendSigned: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex]
                    .extendContractSigned,
                extendedAt: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex]
                    .extendContractSignedAt,
                rejectReason: apartmentRequestsApiModel
                    .guests![apartmentRequestsApiModel.guestIndex]
                    .extendingRejectReason,
              ),
              updateData
            ),
          ),
          title: title);
    } else {
      AppBottomSheet.openAppBottomSheet(
          context: context,
          child: SizedBox(
            height: 200.h,
            width: double.infinity,
            child: ExtendContract(
              ExtendContractModel(
                bookingId: apartmentRequestsApiModel.bookingId ?? "",
                guestId: apartmentRequestsApiModel
                        .guests?[apartmentRequestsApiModel.guestIndex]
                        .guestId ??
                    "",
                startDate: apartmentRequestsApiModel.checkOut == null
                    ? null
                    : DateFormat("M/d/yyyy")
                        .parse(apartmentRequestsApiModel.checkOut ?? "", false),
              ),
              updateData
            ),
          ),
          title: translate(LocalizationKeys.extendContract)!);
    }
  }

  Future<void> _openMap({required String mapLink}) async {
    if (await canLaunchUrlString(mapLink)) {
      await launchUrlString(mapLink, mode: LaunchMode.externalApplication);
    }
  }
}
