import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/checkout/review/review_send_model.dart';
import 'package:vivas/feature/arriving_details/Models/arriving_details_request_model.dart';
import 'package:vivas/feature/arriving_details/Screen/arriving_details.dart';
import 'package:vivas/feature/bookings/screen/apartment_rules.dart';
import 'package:vivas/feature/bookings/screen/booking_summry.dart';
import 'package:vivas/feature/bookings/screen/hand_over_screen.dart';
import 'package:vivas/feature/bookings/screen/select_tenant_for_paid.dart';
import 'package:vivas/feature/bookings/screen/selfie_screen.dart';
import 'package:vivas/feature/bookings/screen/take_image_for_profile.dart';
import 'package:vivas/feature/checkout/checkout_details/screen/checkout_details_screen.dart';
import 'package:vivas/feature/contact_support/screen/contact_support_screen.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/screen/check_in_details_screen.dart';
import 'package:vivas/feature/contract/prepare_check_in/screen/prepare_check_in_screen.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_contract_screen_v2.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';
import 'package:vivas/feature/request_details/request_details/screen/invoice_screen_v2.dart';
import 'package:vivas/feature/request_details/request_details/widget/attention_cancel_request_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/change_request_date_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/next_invoice_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/reject_reason_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/review_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/successfully_cancel_request_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/successfully_send_review_widget.dart';
import 'package:vivas/feature/request_details/request_passport/screen/request_passport_screen_v2.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/modal_sheet/base_bottom_sheet_widget.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../../apis/models/booking/booking_details_model.dart';
import '../../../../preferences/preferences_manager.dart';
import '../widget/cancel_request_widget.dart';
import '../widget/request_widget_v2.dart';
import 'invoice_pay_rent_screen_v2.dart';

class RequestDetailsScreenV2 extends StatelessWidget {
  RequestDetailsScreenV2({Key? key}) : super(key: key);
  static const routeName = '/request-details-screen-v2';
  static const argumentRequestId = 'requestId';
  static const argumentRequestStatus = 'status';

  static Future<void> open(
      BuildContext context, String requestId, ) async {
    Navigator.of(context).pushNamed(routeName, arguments: {
      argumentRequestId: requestId,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestDetailsBloc>(
      create: (context) => RequestDetailsBloc(RequestDetailsRepository(
        apartmentRequestsApiManger:
            ApartmentRequestsApiManger(dioApiManager, context),
        paymentApiManger: PaymentApiManger(dioApiManager, context),
      )),
      child: RequestDetailsScreenWithBloc(
        requestId(context),
      ),
    );
  }

  String requestId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[RequestDetailsScreenV2.argumentRequestId] as String;

  String status(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[RequestDetailsScreenV2.argumentRequestStatus] as String;
}

class RequestDetailsScreenWithBloc extends BaseStatefulScreenWidget {
  final String requestId;

  const RequestDetailsScreenWithBloc(this.requestId, {super.key});

  @override
  BaseScreenState<RequestDetailsScreenWithBloc> baseScreenCreateState() {
    return _RequestDetailsScreenScreenWithBloc();
  }
}

class _RequestDetailsScreenScreenWithBloc
    extends BaseScreenState<RequestDetailsScreenWithBloc> {
  BookingDetailsModel? _bookingDetailsModel;
  var preferencesManager = GetIt.I<PreferencesManager>();

  @override
  void initState() {
    Future.microtask(_getRequestDetailsApiEvent);
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      body: BlocListener<RequestDetailsBloc, RequestDetailsState>(
        listener: (context, state) {
          if (state is RequestDetailLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is RequestDetailErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is RequestDetailsLoadedStateV2) {
            _bookingDetailsModel = state.bookingDetailsModel;
          } else if (state is UpdateRequestDatesState) {
            _getRequestDetailsApiEvent();
          } else if (state is CancelRequestSuccessfullyState) {
            _getRequestDetailsApiEvent();
            _showSuccessfullyCancelRequestSheet();
          } else if (state is UpdateApproveRejectOfferState) {
            _getRequestDetailsApiEvent();
          } else if (state is ReviewSentSuccessfullyState) {
            _showSuccessfullySendReviewSheet();
          }
        },
        child: _detailsWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Widget _detailsWidget() {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      buildWhen: (previous, current) => current is RequestDetailsLoadedStateV2,
      builder: (context, state) {
        if (state is RequestDetailsLoadedStateV2) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Durations.long4, _getRequestDetailsApiEvent);
            },
            child: RequestWidgetV2(
              status: (_bookingDetailsModel?.bookingStatus ?? ""),
              actionBottomTitle: _actionBottomTittle,
              actionClickedCallBack: state.bookingDetailsModel.canContinue
                  ? _actionClicked
                  : _actionClickedWhenCantContinue,
              cancelClickedCallBack: state.bookingDetailsModel.canCancel
                  ? automaticCancelClicked
                  : null,
              //: cancelClicked,
              changeDateClickedCallBack:
                  state.bookingDetailsModel.canEdit ? changeDateClicked : null,
              changeCheckInDetails: !state.bookingDetailsModel.readyToCheckOut
                  ? changeCheckInClicked
                  : null,
              checkInDetailsClickedCallBack: _checkInDetailsClicked,
              massageUsClickedCallBack: _massageUsClicked,
              showApartmentClickedCallBack: _showApartmentClicked,
              apartmentRequestsApiModel: state.bookingDetailsModel,
              acceptOfferClickedCallBack: () => _acceptRejectOffer(true, ""),
              rejectOfferClickedCallBack: () => _acceptRejectOffer(false, ""),
            ),
          );
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  RequestDetailsBloc get currentBloc =>
      BlocProvider.of<RequestDetailsBloc>(context);

  void _getRequestDetailsApiEvent() {
    currentBloc.add(GetRequestDetailsApiEvent(widget.requestId));
  }

  void _changeDateRequestApiEvent(DateTime checkInDate, DateTime checkOutDate) {
    currentBloc.add(
        ChangeDateRequestApiEvent(widget.requestId, checkInDate, checkOutDate));
  }

  void _acceptRejectOffer(bool status, String? notes) {
    currentBloc
        .add(ApproveRejectOfferApiEvent(widget.requestId, status, notes));
  }

  void _cancelRequestApiEvent(String reason, DateTime? terminationDate) {
    currentBloc.add(CancelRequestApiEvent(
      widget.requestId,
      reason,
      terminationDate,
      guestId: _bookingDetailsModel!
              .guests?[_bookingDetailsModel!.guestIndex].guestId ??
          "",
    ));
  }

  get _actionBottomTittle {
    // if (_bookingDetailsModel!.rejected) {
    //   return translate(LocalizationKeys.rejectReason)!;
    // } else if (_bookingDetailsModel!.nextInvoiceModel != null) {
    //   return "${translate(LocalizationKeys.payInvoice)!} - ${AppDateFormat.formattingOnlyYearMonth(_bookingDetailsModel!.nextInvoiceModel!.invDate, appLocale.locale.languageCode)}";
    // } else if (_bookingDetailsModel!.isRefunded) {
    //   return translate(LocalizationKeys.refunded);
    // } else if (_bookingDetailsModel!.isWaitingRefund) {
    //   return translate(LocalizationKeys.waitingForRefund);
    // } else if (!_bookingDetailsModel!.isCheckoutSheetReady &&
    //     _bookingDetailsModel!.isReviewd) {
    //   return translate(LocalizationKeys.waitingCheckoutSheet);
    // } else if (_bookingDetailsModel!.isReadyCheck &&
    //     !_bookingDetailsModel!.isReviewd) {
    //   return translate(LocalizationKeys.reviewBooking);
    // } else if (_bookingDetailsModel!.isReadyCheck &&
    //     _bookingDetailsModel!.isCheckoutSheetReady) {
    //   return translate(LocalizationKeys.continueForCheckout);
    // } else if (_bookingDetailsModel!.isCheckedout &&
    //     _bookingDetailsModel!.isCashDeposit) {
    //   return translate(LocalizationKeys.waitingForRefund);
    // } else if (_bookingDetailsModel!.terminationRequest) {
    //   return translate(LocalizationKeys.yourTerminationUnderReview);
    // } else if (_bookingDetailsModel!.requestStatus == "Pending") {
    //   return translate(LocalizationKeys.continuee)!;
    // } else if (!_bookingDetailsModel!.hasUploadedImg) {
    //   return translate(LocalizationKeys.uploadPassport)!;
    // } else if (_bookingDetailsModel!.haveInvaliPassport &&
    //     _bookingDetailsModel!.hasUploadedImg) {
    //   return translate(LocalizationKeys.passportreview)!;
    // } else if (_bookingDetailsModel!.haveInvalidData) {
    //   return translate(LocalizationKeys.passportRejected)!;
    // } /*else if (_apartmentRequestsApiModel!.haveInvaliPassport) {
    //   return translate(LocalizationKeys.passportreview)!;
    // } */
    // else if (!_bookingDetailsModel!.signedContract &&
    //     _bookingDetailsModel!.createdContract) {
    //   return translate(LocalizationKeys.signYourContract)!;
    // } else if (_bookingDetailsModel!.nextInvoiceModel != null) {
    //   return "${translate(LocalizationKeys.payInvoice)!} - ${AppDateFormat.formattingOnlyYearMonth(_bookingDetailsModel!.nextInvoiceModel!.invDate, appLocale.locale.languageCode)}";
    // } else if (_bookingDetailsModel!.checked) {
    //   return translate(LocalizationKeys.checkInAndRentalRulesDetails)!;
    // } else if (_bookingDetailsModel!.signedContract) {
    //   return translate(LocalizationKeys.prepareYourCheckIn)!;
    // } else if (_bookingDetailsModel!.fullPaid &&
    //     _bookingDetailsModel!.createdContract) {
    //   return translate(LocalizationKeys.signYourContract)!;
    // } else if (_bookingDetailsModel!.fullPaid &&
    //     !_bookingDetailsModel!.createdContract) {
    //   return translate(LocalizationKeys.wePreparingYourContract)!;
    // } else if (_bookingDetailsModel!.isCashed &&
    //     !_bookingDetailsModel!.fullPaid) {
    //   return translate(LocalizationKeys.confirmCashPayment)!;
    // } else {
    //   return translate(LocalizationKeys.continuee)!;
    // }
    if ((_bookingDetailsModel?.bookingStatus ?? "") == "Cancelled" ||
        (_bookingDetailsModel?.bookingStatus ?? "") == "Rejected") {
      return "${_bookingDetailsModel?.bookingStatus ?? ""} Reason";
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.needToUploadPassport ?? false)) {
      return translate(LocalizationKeys.uploadPassport)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.haveRejectPassport ?? false)) {
      return translate(LocalizationKeys.passportRejected)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.passportInReview ?? false)) {
      return translate(LocalizationKeys.passportreview)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.paidSecurityDeposit ?? false) &&
        (_bookingDetailsModel?.canResumeBookingAsMainTenant ?? false)) {
      return translate(LocalizationKeys.paySecurityDeposit)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.signContract ?? false) &&
        (_bookingDetailsModel?.canResumeBookingAsMainTenant ?? false)) {
      return translate(LocalizationKeys.signContract)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.goToArrivingDetails ?? false)) {
      return translate(LocalizationKeys.arrivingDetails)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.goToArrivingDetails ?? false) &&
        DateFormat("MM/dd/yyyy")
            .parse(_bookingDetailsModel?.checkIn ?? "")
            .isAfter(DateTime.now())) {
      return translate(LocalizationKeys.waitingForCheckIn)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.goToArrivingDetails ?? false) &&
        !DateFormat("MM/dd/yyyy")
            .parse(_bookingDetailsModel?.checkIn ?? "")
            .isAfter(DateTime.now()) &&
        !(_bookingDetailsModel?.scannedQR ?? false)) {
      return translate(LocalizationKeys.checkIn2)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.isSelfie ?? false)) {
      return translate(LocalizationKeys.verificationIdentity)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.paidRent ?? false) &&
        !(_bookingDetailsModel?.handOverSigned ?? false) &&
        (_bookingDetailsModel?.canResumeBookingAsMainTenant ?? false)) {
      return translate(LocalizationKeys.payRent)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.handOverSigned ?? false)) {
      return translate(LocalizationKeys.signHandoverProtocols)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.rentalRulesSigned ?? false)) {
      return translate(LocalizationKeys.signRentalRules)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Pending") {
      return translate(LocalizationKeys.bookingReview)!;
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Rejected") {
      return translate(LocalizationKeys.rejectReason)!;
    } else if (_bookingDetailsModel!.getMonthlyInvoice != null &&
        (_bookingDetailsModel!.getMonthlyInvoice!.isCashed ?? false) &&
        DateFormat("MM/dd/yyyy")
                .parse(_bookingDetailsModel?.checkIn ?? "")
                .month ==
            DateTime.now().month &&
        _bookingDetailsModel!.canResumeBookingAsMainTenant) {
      return translate(LocalizationKeys.confirmCashPayment)!;
    } else if (_bookingDetailsModel?.getMonthlyInvoice != null) {
      return translate(LocalizationKeys.monthlyRent)!;
    } else if (_bookingDetailsModel?.readyToCheckOut ?? false) {
      return translate(LocalizationKeys.checkOutSheetDetails)!;
    } else if (!(_bookingDetailsModel?.paidRent ?? false) &&
        (_bookingDetailsModel?.handOverSigned ?? false) &&
        (_bookingDetailsModel?.canResumeBookingAsMainTenant ?? false)) {
      return translate(LocalizationKeys.confirmCashPayment)!;
    } else {
      return translate(LocalizationKeys.waitingForMonthlyInvoices)!;
    }
  }

  void _actionClicked() {
    if ((_bookingDetailsModel?.bookingStatus ?? "") == "Cancelled" ||
        (_bookingDetailsModel?.bookingStatus ?? "") == "Rejected") {
      _showRejectedReason();
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.needToUploadPassport ?? false)) {
      RequestPassportScreenV2.open(context, _bookingDetailsModel!,
              fromRejected: false)
          .then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.passportInReview ?? false)) {
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.haveRejectPassport ?? false)) {
      RequestPassportScreenV2.open(context, _bookingDetailsModel!,
              fromRejected: true)
          .then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.paidSecurityDeposit ?? false) &&
        (_bookingDetailsModel?.canResumeBookingAsMainTenant ?? false)) {
      InvoiceScreenV2.open(
              context, _bookingDetailsModel!, _getRequestDetailsApiEvent)
          .then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.signContract ?? false) &&
        (_bookingDetailsModel?.canResumeBookingAsMainTenant ?? false)) {
      SignContractScreenV2.open(
              context, _bookingDetailsModel!, false, _getRequestDetailsApiEvent)
          .then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.goToArrivingDetails ?? false)) {
      ArrivingDetails.open(
        context,
        ArrivingDetailsRequestModel(
          bookingId: _bookingDetailsModel?.bookingId ?? "",
          guestId: _bookingDetailsModel
                  ?.guests?[_bookingDetailsModel?.guestIndex ?? 0].guestId ??
              "",
        ),
        _bookingDetailsModel!,
        false,
      ).then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.goToArrivingDetails ?? false) &&
        DateFormat("MM/dd/yyyy")
            .parse(_bookingDetailsModel?.checkIn ?? "")
            .isAfter(DateTime.now())) {
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        (_bookingDetailsModel?.goToArrivingDetails ?? false) &&
        !DateFormat("MM/dd/yyyy")
            .parse(_bookingDetailsModel?.checkIn ?? "")
            .isAfter(DateTime.now()) &&
        !(_bookingDetailsModel?.scannedQR ?? false)) {
      BookingSummary.open(
              context,
              _bookingDetailsModel!,
              _bookingDetailsModel!.guests![_bookingDetailsModel!.guestIndex],
              _bookingDetailsModel?.apartmentLocation ?? "",
              _getRequestDetailsApiEvent)
          .then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.isSelfie ?? false)) {
      _bookingDetailsModel?.guestNeedToUploadProfileImage ?? true
          ? TakeSelfieScreen.open(context, _bookingDetailsModel!, true,
                  _getRequestDetailsApiEvent)
              .then((value) => _getRequestDetailsApiEvent())
          : SelfieScreen.open(context, _bookingDetailsModel!, true,
                  _getRequestDetailsApiEvent)
              .then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.paidRent ?? false) &&
        !(_bookingDetailsModel?.handOverSigned ?? false) &&
        (_bookingDetailsModel?.canResumeBookingAsMainTenant ?? false)) {
      if (_bookingDetailsModel?.fullBooking ??
          false && _bookingDetailsModel!.canResumeBookingAsMainTenant) {
        InvoicePayRentScreenV2.open(context, _bookingDetailsModel!, false,
                _getRequestDetailsApiEvent)
            .then((value) => _getRequestDetailsApiEvent());
      } else if (_bookingDetailsModel!.isSingleGuest) {
        InvoicePayRentScreenV2.open(context, _bookingDetailsModel!, false,
                _getRequestDetailsApiEvent)
            .then((value) => _getRequestDetailsApiEvent());
      } else {
        SelectTenantForPay.open(context, _bookingDetailsModel!, false,
                _getRequestDetailsApiEvent)
            .then((value) => _getRequestDetailsApiEvent());
      }
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.handOverSigned ?? false)) {
      HandoverProtocolsScreen.open(
        context,
        _bookingDetailsModel!,
        _getRequestDetailsApiEvent,
      ).then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Approved" &&
        !(_bookingDetailsModel?.rentalRulesSigned ?? false)) {
      ApartmentRulesScreen.open(
              context, _bookingDetailsModel!, false, _getRequestDetailsApiEvent)
          .then((value) => _getRequestDetailsApiEvent());
    } else if ((_bookingDetailsModel?.bookingStatus ?? "") == "Rejected") {
      _showRejectedReason();
    } else if (_bookingDetailsModel!.getMonthlyInvoice != null &&
        (_bookingDetailsModel!.getMonthlyInvoice!.isCashed ?? false) &&
        DateFormat("MM/dd/yyyy")
                .parse(_bookingDetailsModel?.checkIn ?? "")
                .month ==
            DateTime.now().month &&
        _bookingDetailsModel!.canResumeBookingAsMainTenant) {
      //don't do anything
    } else if (_bookingDetailsModel!.getMonthlyInvoice != null &&
        _bookingDetailsModel!.canResumeBookingAsMainTenant) {
      _showNextInvoiceSheet();
    } else if (_bookingDetailsModel!.readyToCheckOut) {
      _checkReviewAndGoToCheckout();
    } else {}
  }

  void _actionClickedWhenCantContinue() {
    if ((_bookingDetailsModel?.bookingStatus ?? "") == "Cancelled" ||
        (_bookingDetailsModel?.bookingStatus ?? "") == "Rejected") {
      _showRejectedReason();
    } else {
      null;
    }
  }

  void _massageUsClicked() {
    ContactSupportScreen.open(context);
  }

  void _showApartmentClicked() {
    // UnitDetailsScreen.open(context, _bookingDetailsModel!.apartmentId ?? "",
    //     viewOnlyMode: true);
    CheckInDetailsScreen.open(context, _bookingDetailsModel!.bookingId ?? "",
            _bookingDetailsModel!.apartmentId ?? "",
            checkInDetailsResponse:
                _bookingDetailsModel?.checkInDetailsResponse)
        .then((value) => _getRequestDetailsApiEvent());
  }

  void _checkInDetailsClicked() {
    CheckInDetailsScreen.open(context, _bookingDetailsModel!.bookingId ?? "",
        _bookingDetailsModel!.apartmentId ?? "");
  }

  void changeDateClicked() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: ChangeRequestDateWidget(
          saveCallBack: _changeDateRequestApiEvent,
          startDate: AppDateFormat.appDateFormApiParse(
              _bookingDetailsModel!.checkIn ?? ""),
          endDate: AppDateFormat.appDateFormApiParse(
              _bookingDetailsModel!.checkOut ?? ""),
        ),
        title: translate(LocalizationKeys.changeDates)!);
  }

  void changeCheckInClicked() {
    PrepareCheckInScreen.open(context, widget.requestId)
        .then((value) => _getRequestDetailsApiEvent());
  }

  void cancelClicked() async {
    bool? cancel = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BaseBottomSheetWidget(
            onCloseCallBack: null,
            title: translate(!(_bookingDetailsModel?.canCancel ?? false)
                ? LocalizationKeys.terminationBooking
                : LocalizationKeys.cancelBooking)!,
            child: AttentionCancelRequestWidget(
              sendCallBack: _cancelRequestApiEvent,
              showTerminationDate:
                  (_bookingDetailsModel?.bookingStatus ?? "") == "Approved"
                      ? false
                      : true,
            ),
          ),
        );
      },
    );
    if (cancel == true) {
      automaticCancelClicked();
    }
  }

  void automaticCancelClicked() async {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: CancelRequestWidget(
            sendCallBack: _cancelRequestApiEvent,
            showTerminationDate:
                (_bookingDetailsModel?.canCancel ?? false) ? false : true),
        title: translate(LocalizationKeys.cancelBooking)!);
  }

  void _showRejectedReason() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: RejectReasonWidget(
            rejectReason: _bookingDetailsModel!.rejectReason ?? ""),
        title: "${_bookingDetailsModel?.bookingStatus ?? ""} Reason");
  }

  void _showSuccessfullyCancelRequestSheet() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: SuccessfullyCancelRequestWidget(),
        title: translate(LocalizationKeys.cancelBooking)!);
  }

  void _sendReviewApiEvent(ReviewSendModel model) {
    currentBloc.add(SendReviewApiEvent(model));
  }

  void _checkReviewAndGoToCheckout() {
    _bookingDetailsModel!.isReviewed
        ? _bookingDetailsModel!.readyToCheckOut
            ? _openCheckoutDetailsScreen()
            : null
        : showReviewBottomSheet();
  }

  void _openCheckoutDetailsScreen() {
    CheckoutDetailsScreen.open(context, widget.requestId)
        .then((value) => _getRequestDetailsApiEvent());
  }

  //open in actionButton (not reviewed)
  void showReviewBottomSheet() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: ReviewWidget(
          onSendReviewClicked: (p0, p1, p2, p3, p4, p5, p6) {
            //call event
            _sendReviewApiEvent(ReviewSendModel(
                reqID: widget.requestId,
                rateApartment: p0,
                rateSafety: p1,
                rateLocation: p2,
                rateService: p3,
                rateCleanliness: p4,
                rateCommunication: p5,
                reviewComment: p6 ?? ""));
          },
        ),
        title: translate(LocalizationKeys.customerReview)!);
  }

  //open in actionButton (reviewed) & after review
  void _showSuccessfullySendReviewSheet() {
    AppBottomSheet.openAppBottomSheet(
      context: context,
      child: SuccessfullySendReviewWidget(
        onGoButtonClick: () {
          _getRequestDetailsApiEvent();
          // open checkout
          // CheckoutDetailsScreen.open(
          //         context, _apartmentRequestsApiModel!.requestId)
          //     .then((value) => {_getRequestDetailsApiEvent()});
        },
      ),
      title: "",
      onCloseCallBack: () {
        //update request
        _getRequestDetailsApiEvent();
      },
    );
  }

  Future<void> _showNextInvoiceSheet() async {
    await AppBottomSheet.openAppBottomSheet(
        context: context,
        child: NextInvoiceWidget(
            NextInvoiceModel(
              monthInvID:
                  _bookingDetailsModel?.getMonthlyInvoice?.monthInvId ?? "",
              invDate: _bookingDetailsModel?.getMonthlyInvoice?.invDate ??
                  DateTime.now(),
              invTotal:
                  _bookingDetailsModel?.getMonthlyInvoice?.invTotal ?? 0.0,
              isCashed:
                  _bookingDetailsModel?.getMonthlyInvoice?.isCashed ?? false,
            ),
            _bookingDetailsModel!.getMonthlyInvoice!.isCashed ?? false,
            _bookingDetailsModel!,
            _getRequestDetailsApiEvent),
        title: translate(LocalizationKeys.monthlyRent)!);
  }
}
