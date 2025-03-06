//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/UploadPassportRequestModel/passport_request_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/guests_request_model.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/request_details/request_details/screen/complete_your_booking_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/request_details_screen.dart';
import 'package:vivas/feature/request_details/request_passport/bloc/request_passport_bloc.dart';
import 'package:vivas/feature/request_details/request_passport/bloc/request_passport_repository.dart';
import 'package:vivas/feature/request_details/request_passport/widget/tenant_widget.dart';
import 'package:vivas/feature/request_details/request_passport/widget/tenant_widget_v2.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class RequestPassportScreenV2 extends StatelessWidget {
  RequestPassportScreenV2({Key? key}) : super(key: key);
  static const routeName = '/request-passport-screen-v2';
  static const argumentApartmentRequestsApiModel = 'apartmentRequestsApiModel';
  static const argumentFromRejected = 'fromRejected';

  static Future<void> open(
      BuildContext context, BookingDetailsModel bookingDetailsModel,
      {bool fromRejected = false}) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentApartmentRequestsApiModel: bookingDetailsModel,
      argumentFromRejected: fromRejected,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestPassportBloc>(
      create: (context) => RequestPassportBloc(RequestPassportRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentRequestsApiManger:
            ApartmentRequestsApiManger(dioApiManager, context),
      )),
      child: RequestPassportScreenWithBloc(
          apartmentRequestsApiModel(context), closeAfterUpdate(context)),
    );
  }

  BookingDetailsModel apartmentRequestsApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[RequestPassportScreenV2.argumentApartmentRequestsApiModel]
          as BookingDetailsModel;

  bool closeAfterUpdate(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[RequestPassportScreenV2.argumentFromRejected] as bool;
}

class RequestPassportScreenWithBloc extends BaseStatefulScreenWidget {
  final BookingDetailsModel apartmentRequestsApiModel;
  final bool fromRejected;

  const RequestPassportScreenWithBloc(
      this.apartmentRequestsApiModel, this.fromRejected,
      {super.key});

  @override
  BaseScreenState<RequestPassportScreenWithBloc> baseScreenCreateState() {
    return _RequestPassportScreenWithBloc();
  }
}

class _RequestPassportScreenWithBloc
    extends BaseScreenState<RequestPassportScreenWithBloc> {
  List<PassportRequestModel> guestList = [];
  bool haveUpdate = false;

  @override
  void initState() {
    if (widget.fromRejected) {
      for (int x = 0;
          x < (widget.apartmentRequestsApiModel.guests?.length ?? 0);
          x++) {
        var e = widget.apartmentRequestsApiModel.guests![x];
        if (e.passportStatus == "Rejected") {
          guestList.add(PassportRequestModel(
              guestName: e.guestName ?? "",
              guestId: e.guestId ?? "",
              bedId: e.bedId ?? "",
              status: e.passportStatus == "Uploading" ? null : e.passportStatus,
              passportImgRejected:
                  e.guestPassport == null || e.guestPassport!.isNotEmpty
                      ? e.guestPassport
                      : null,
              validPassport: e.passportStatus != "Rejected",
              invalidReason: e.passportRejectReason));
        }
      }
    } else {
      for (int x = 0;
          x < (widget.apartmentRequestsApiModel.guests?.length ?? 0);
          x++) {
        var e = widget.apartmentRequestsApiModel.guests![x];
        if (e.passportStatus != "Approved" && e.passportStatus != 'InReview') {
          guestList.add(PassportRequestModel(
              guestName: e.guestName ?? "",
              guestId: e.guestId ?? "",
              bedId: e.bedId ?? "",
              status: e.passportStatus == "Uploading" ? null : e.passportStatus,
              passportImgRejected:
                  e.guestPassport == null || e.guestPassport!.isNotEmpty
                      ? e.guestPassport
                      : null,
              validPassport: e.passportStatus != "Rejected",
              invalidReason: e.passportRejectReason));
        }
      }
      // guestList = widget.apartmentRequestsApiModel.guests!
      //     .map((e) => PassportRequestModel(
      //         guestName: e.guestName ?? "",
      //         guestId: e.guestId ?? "",
      //         bedId: e.bedId ?? "",
      //         status: e.passportStatus == "Uploading" ? null :e.passportStatus,
      //         passportImg:e.guestPassport==null || e.guestPassport!.isNotEmpty? e.guestPassport : null,
      //         validPassport: e.passportStatus != "Rejected",
      //         invalidReason: e.passportRejectReason)
      // )
      //     .toList();
    }

    _checkFirstTimeUpdate();
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate(LocalizationKeys.passport)!)),
      body: BlocConsumer<RequestPassportBloc, RequestPassportState>(
        listener: (context, state) {
          if (state is RequestPassportLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is RequestPassportErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is UpdateGuestRequestInfoStateV2) {
            haveUpdate = true;
            _updateList(state.oldData, state.newData);
          } else if (state is UpdateGuestListSuccessfullyStateV2) {
            showFeedbackMessage(state.message);
            //  widget.apartmentRequestsApiModel.expireReq = state.expiredDate;
            _nextStep();
          }
        },
        builder: (context, state) => _detailsWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _detailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(LocalizationKeys
                        .pleaseUploadThePassportsOfEachTenantWithYouSoThatWeCanPrepareYourContract)!,
                    style: const TextStyle(
                      color: Color(0xFF1B1B2F),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  if (widget.fromRejected) ...[
                    ...guestList
                        .map(
                          (e) => e.isInValidData
                              ? TenantWidgetV2(
                                  canEdit: e.status == "Approved"
                                      ? false
                                      : widget.fromRejected
                                          ? e.isInValidData
                                          : false,
                                  guestsRequestModel: PassportRequestModel(
                                    guestId: e.guestId,
                                    bedId: e.bedId ?? "",
                                    guestName: e.guestName,
                                    passportImg: e.passportImg,
                                    passportImgRejected: e.passportImgRejected,
                                    invalidReason: e.invalidReason,
                                    validName: e.validName,
                                    validPassport: e.validPassport,
                                  ),
                                  afterEditCallBack: (PassportRequestModel
                                      guestsRequestModel) {
                                    _updateGuestData(e, guestsRequestModel);
                                  },
                                )
                              : Container(),
                        )
                        .toList()
                  ] else ...[
                    ...guestList
                        .map((e) => TenantWidgetV2(
                              canEdit: e.status == "Approved"
                                  ? false
                                  : widget.fromRejected
                                      ? e.isInValidData
                                      : false,
                              guestsRequestModel: PassportRequestModel(
                                guestId: e.guestId,
                                bedId: e.bedId ?? "",
                                guestName: e.guestName,
                                passportImg: e.passportImg,
                                invalidReason: e.invalidReason,
                                validName: e.validName,
                                status: e.status,
                                validPassport: e.validPassport,
                              ),
                              afterEditCallBack:
                                  (PassportRequestModel guestsRequestModel) {
                                _updateGuestData(e, guestsRequestModel);
                              },
                            ))
                        .toList()
                  ],
                ],
              ),
            ),
          ),
        ),
        SubmitButtonWidget(
          title: translate(
              haveUpdate ? LocalizationKeys.send : LocalizationKeys.continuee)!,
          onClicked: allGuestDataIsValid ? _sendClicked : null,
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  RequestPassportBloc get currentBloc =>
      BlocProvider.of<RequestPassportBloc>(context);

  void _updateGuestData(
      PassportRequestModel oldData, PassportRequestModel newData) {
    currentBloc.add(UpdateGuestRequestInfoEventV2(oldData, newData));
  }

  bool get allGuestDataIsValid {
    return !guestList.any((element) => (element.passportImg == null));
  }

  void _sendClicked() {
    if (haveUpdate) {
      currentBloc.add(UpdateGuestRequestListApiEventV2(
          widget.apartmentRequestsApiModel.bookingId ?? "", guestList));
    } else {
      _nextStep();
    }
  }

  void _nextStep() {
    if (widget.fromRejected) {
      Navigator.of(context).pop();
    } else {
      _openBookingRequest();
      //_openSecurityDepositPaymentScreen();
    }
  }

  void _openBookingRequest() {
    Navigator.of(context).pop();
  }

  // ignore: unused_element
  void _openSecurityDepositPaymentScreen() {
    // CompleteYourBookingScreen.open(context, widget.apartmentRequestsApiModel,
    //     openWithReplacement: true);
  }

  void _updateList(PassportRequestModel oldData, PassportRequestModel newData) {
    int i = guestList.indexWhere((guest) => guest.bedId == oldData.bedId);
    guestList[i] = newData;
  }

  void _checkFirstTimeUpdate() {
    haveUpdate = guestList.any((element) => element.passportImg == null);
  }
}
