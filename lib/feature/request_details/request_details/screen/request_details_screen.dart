import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/checkout/review/review_send_model.dart';
import 'package:vivas/feature/checkout/checkout_details/screen/checkout_details_screen.dart';
import 'package:vivas/feature/contact_support/screen/contact_support_screen.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/screen/check_in_details_screen.dart';
import 'package:vivas/feature/contract/prepare_check_in/screen/prepare_check_in_screen.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_contract_screen.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';
import 'package:vivas/feature/request_details/request_details/screen/complete_your_booking_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/security_deposit_screen.dart';
import 'package:vivas/feature/request_details/request_details/widget/attention_cancel_request_widget.dart';

import 'package:vivas/feature/request_details/request_details/widget/change_request_date_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/next_invoice_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/reject_reason_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/request_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/review_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/successfully_cancel_request_widget.dart';
import 'package:vivas/feature/request_details/request_details/widget/successfully_send_review_widget.dart';
import 'package:vivas/feature/request_details/request_passport/screen/request_passport_screen.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';

import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class RequestDetailsScreen extends StatelessWidget {
  RequestDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/request-details-screen';
  static const argumentRequestId = 'requestId';

  static Future<void> open(BuildContext context, String requestId) async {
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
      child: RequestDetailsScreenWithBloc(requestId(context)),
    );
  }

  String requestId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[RequestDetailsScreen.argumentRequestId] as String;
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
  ApartmentRequestsApiModel? _apartmentRequestsApiModel;

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
          } else if (state is RequestDetailsLoadedState) {
            _apartmentRequestsApiModel = state.apartmentRequestsApiModel;
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
      buildWhen: (previous, current) => current is RequestDetailsLoadedState,
      builder: (context, state) {
        if (state is RequestDetailsLoadedState) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Durations.long4, _getRequestDetailsApiEvent);
            },
            child: RequestWidget(
              actionBottomTitle: _actionBottomTittle,
              actionClickedCallBack: state.apartmentRequestsApiModel.canContinue
                  ? _actionClicked
                  : null,
              cancelClickedCallBack: state.apartmentRequestsApiModel.canCancel
                  ? cancelClicked
                  : null,
              changeDateClickedCallBack: state.apartmentRequestsApiModel.canEdit
                  ? changeDateClicked
                  : null,
              changeCheckInDetails:
                  state.apartmentRequestsApiModel.changeCheckIn &
                          !state.apartmentRequestsApiModel.isReadyCheck
                      ? changeCheckInClicked
                      : null,
              checkInDetailsClickedCallBack: _checkInDetailsClicked,
              massageUsClickedCallBack: _massageUsClicked,
              showApartmentClickedCallBack: _showApartmentClicked,
              apartmentRequestsApiModel: state.apartmentRequestsApiModel,
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
    currentBloc
        .add(CancelRequestApiEvent(widget.requestId, reason, terminationDate));
  }

  get _actionBottomTittle {
    if (_apartmentRequestsApiModel!.rejected) {
      return translate(LocalizationKeys.rejectReason)!;
    } else if (_apartmentRequestsApiModel!.nextInvoiceModel != null) {
      return "${translate(LocalizationKeys.payInvoice)!} - ${AppDateFormat.formattingOnlyYearMonth(_apartmentRequestsApiModel!.nextInvoiceModel!.invDate, appLocale.locale.languageCode)}";
    } else if (_apartmentRequestsApiModel!.isRefunded) {
      return translate(LocalizationKeys.refunded);
    } else if (_apartmentRequestsApiModel!.isWaitingRefund) {
      return translate(LocalizationKeys.waitingForRefund);
    } else if (!_apartmentRequestsApiModel!.isCheckoutSheetReady &&
        _apartmentRequestsApiModel!.isReviewd) {
      return translate(LocalizationKeys.waitingCheckoutSheet);
    } else if (_apartmentRequestsApiModel!.isReadyCheck &&
        !_apartmentRequestsApiModel!.isReviewd) {
      return translate(LocalizationKeys.reviewBooking);
    } else if (_apartmentRequestsApiModel!.isReadyCheck &&
        _apartmentRequestsApiModel!.isCheckoutSheetReady) {
      return translate(LocalizationKeys.continueForCheckout);
    } else if (_apartmentRequestsApiModel!.isCheckedout &&
        _apartmentRequestsApiModel!.isCashDeposit) {
      return translate(LocalizationKeys.waitingForRefund);
    } else if (_apartmentRequestsApiModel!.terminationRequest) {
      return translate(LocalizationKeys.yourTerminationUnderReview);
    } else if (_apartmentRequestsApiModel!.requestStatus == "Pending") {
      return translate(LocalizationKeys.continuee)!;
    } else if (!_apartmentRequestsApiModel!.hasUploadedImg) {
      return translate(LocalizationKeys.uploadPassport)!;
    } else if (_apartmentRequestsApiModel!.haveInvaliPassport &&
        _apartmentRequestsApiModel!.hasUploadedImg) {
      return translate(LocalizationKeys.passportreview)!;
    } else if (_apartmentRequestsApiModel!.haveInvalidData) {
      return translate(LocalizationKeys.passportRejected)!;
    }
    /*else if (_apartmentRequestsApiModel!.haveInvaliPassport) {
      return translate(LocalizationKeys.passportreview)!;
    } */
    else if (!_apartmentRequestsApiModel!.signedContract &&
        _apartmentRequestsApiModel!.createdContract) {
      return translate(LocalizationKeys.signYourContract)!;
    } else if (_apartmentRequestsApiModel!.nextInvoiceModel != null) {
      return "${translate(LocalizationKeys.payInvoice)!} - ${AppDateFormat.formattingOnlyYearMonth(_apartmentRequestsApiModel!.nextInvoiceModel!.invDate, appLocale.locale.languageCode)}";
    } else if (_apartmentRequestsApiModel!.checked) {
      return translate(LocalizationKeys.checkInAndRentalRulesDetails)!;
    } else if (_apartmentRequestsApiModel!.signedContract) {
      return translate(LocalizationKeys.prepareYourCheckIn)!;
    } else if (_apartmentRequestsApiModel!.fullPaid &&
        _apartmentRequestsApiModel!.createdContract) {
      return translate(LocalizationKeys.signYourContract)!;
    } else if (_apartmentRequestsApiModel!.fullPaid &&
        !_apartmentRequestsApiModel!.createdContract) {
      return translate(LocalizationKeys.wePreparingYourContract)!;
    } else if (_apartmentRequestsApiModel!.isCashed &&
        !_apartmentRequestsApiModel!.fullPaid) {
      return translate(LocalizationKeys.confirmCashPayment)!;
    } else {
      return translate(LocalizationKeys.continuee)!;
    }
  }

  void _actionClicked() {
    /*if (_apartmentRequestsApiModel!.rejected) {
      _showRejectedReason();
    } else if (!_apartmentRequestsApiModel!.isCheckedout &&
        _apartmentRequestsApiModel!.isReadyCheck) {
      //checkout
      _checkReviewAndGoToCheckout();
    } else if (!_apartmentRequestsApiModel!.hasuploadedImg) {
      RequestPassportScreen.open(context, _apartmentRequestsApiModel!,
              fromRejected: false)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.haveInvalidData) {
      RequestPassportScreen.open(context, _apartmentRequestsApiModel!,
              fromRejected: true)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.signedContract &&
        _apartmentRequestsApiModel!.nextInvoiceModel == null) {
      PrepareCheckInScreen.open(context, _apartmentRequestsApiModel!.requestId)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (!_apartmentRequestsApiModel!.signedContract &&
        _apartmentRequestsApiModel!.createdContract) {
      SignContractScreen.open(context, _apartmentRequestsApiModel!.requestId)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.nextInvoiceModel != null) {
      _showNextInvoiceSheet();
    } else if (_apartmentRequestsApiModel!.checked &&
        _apartmentRequestsApiModel!.nextInvoiceModel == null) {
      CheckInDetailsScreen.open(context, _apartmentRequestsApiModel!.requestId)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.fullPaid &&
        _apartmentRequestsApiModel!.createdContract) {
      SignContractScreen.open(context, _apartmentRequestsApiModel!.requestId)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.coveredPercentage > 1) {
      SecurityDepositScreen.open(context, _apartmentRequestsApiModel!)
          .then((value) => _getRequestDetailsApiEvent());
    }
    /* else if (_apartmentRequestsApiModel!.isCashed) {
      _showCashInvoice();
    } */
    else {
      CompleteYourBookingScreen.open(context, _apartmentRequestsApiModel!,
          openWithReplacement: true);
      /*  RequestPassportScreen.open(context, _apartmentRequestsApiModel!)
          .then((value) => _getRequestDetailsApiEvent()); */
    }*/

    if (_apartmentRequestsApiModel!.rejected) {
      _showRejectedReason();
    } else if (!_apartmentRequestsApiModel!.isCheckedout &&
        _apartmentRequestsApiModel!.isReadyCheck) {
      //checkout
      _checkReviewAndGoToCheckout();
    } else if (!_apartmentRequestsApiModel!.hasUploadedImg) {
      RequestPassportScreen.open(context, _apartmentRequestsApiModel!,
              fromRejected: false)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.haveInvalidData) {
      RequestPassportScreen.open(context, _apartmentRequestsApiModel!,
              fromRejected: true)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.coveredPercentage == 0) {
      CompleteYourBookingScreen.open(context, _apartmentRequestsApiModel!,
              openWithReplacement: false)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.coveredRemainPercentage > 1) {
      SecurityDepositScreen.open(context, _apartmentRequestsApiModel!)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (!_apartmentRequestsApiModel!.signedContract &&
        _apartmentRequestsApiModel!.createdContract) {
      SignContractScreen.open(context, _apartmentRequestsApiModel!.requestId)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.signedContract &&
        !_apartmentRequestsApiModel!.checked) {
      PrepareCheckInScreen.open(context, _apartmentRequestsApiModel!.requestId)
          .then((value) => _getRequestDetailsApiEvent());
    } else if (_apartmentRequestsApiModel!.nextInvoiceModel != null) {
      _showNextInvoiceSheet();
    } else if (_apartmentRequestsApiModel!.checked &&
        _apartmentRequestsApiModel!.nextInvoiceModel == null) {
      CheckInDetailsScreen.open(context, _apartmentRequestsApiModel!.requestId,
              _apartmentRequestsApiModel!.unitId)
          .then((value) => _getRequestDetailsApiEvent());
    } else {
      // CompleteYourBookingScreen.open(context, _apartmentRequestsApiModel!,
      //     openWithReplacement: true);
      /*  RequestPassportScreen.open(context, _apartmentRequestsApiModel!)
          .then((value) => _getRequestDetailsApiEvent()); */
    }
  }

  void _massageUsClicked() {
    ContactSupportScreen.open(context);
  }

  void _showApartmentClicked() {
    UnitDetailsScreen.open(context, _apartmentRequestsApiModel!.unitId,
        viewOnlyMode: true);
  }

  void _checkInDetailsClicked() {
    CheckInDetailsScreen.open(context, _apartmentRequestsApiModel!.requestId,
        _apartmentRequestsApiModel!.unitId);
  }

  void changeDateClicked() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: ChangeRequestDateWidget(
          saveCallBack: _changeDateRequestApiEvent,
          startDate: _apartmentRequestsApiModel!.startDate,
          endDate: _apartmentRequestsApiModel!.endDate,
        ),
        title: translate(LocalizationKeys.changeDates)!);
  }

  void changeCheckInClicked() {
    PrepareCheckInScreen.open(context, _apartmentRequestsApiModel!.requestId)
        .then((value) => _getRequestDetailsApiEvent());
  }

  void cancelClicked() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: AttentionCancelRequestWidget(
            sendCallBack: _cancelRequestApiEvent,
            showTerminationDate:
                _apartmentRequestsApiModel!.cancelAsTermination),
        title: translate(_apartmentRequestsApiModel!.cancelAsTermination
            ? LocalizationKeys.terminationBooking
            : LocalizationKeys.cancelBooking)!);
  }

  void _showRejectedReason() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: RejectReasonWidget(
            rejectReason: _apartmentRequestsApiModel!.rejectReason),
        title: translate(LocalizationKeys.rejectReason)!);
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
    _apartmentRequestsApiModel!.isReviewd
        ? _apartmentRequestsApiModel!.isCheckoutSheetReady
            ? _openCheckoutDetailsScreen()
            : null
        : showReviewBottomSheet();
  }

  void _openCheckoutDetailsScreen() {
    CheckoutDetailsScreen.open(context, _apartmentRequestsApiModel!.requestId,
            _apartmentRequestsApiModel?.unitId ?? "")
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
                reqID: _apartmentRequestsApiModel!.requestId,
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
    // await AppBottomSheet.openAppBottomSheet(
    //     context: context,
    //     child: NextInvoiceWidget(_apartmentRequestsApiModel!.nextInvoiceModel!,
    //         _apartmentRequestsApiModel!.nextInvoiceModel!.isCashed),
    //     title: "");
  }
}
