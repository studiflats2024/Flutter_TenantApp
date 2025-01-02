//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/guests_request_model.dart';
import 'package:vivas/feature/request_details/request_details/screen/complete_your_booking_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/request_details_screen.dart';
import 'package:vivas/feature/request_details/request_passport/bloc/request_passport_bloc.dart';
import 'package:vivas/feature/request_details/request_passport/bloc/request_passport_repository.dart';
import 'package:vivas/feature/request_details/request_passport/widget/tenant_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class RequestPassportScreen extends StatelessWidget {
  RequestPassportScreen({Key? key}) : super(key: key);
  static const routeName = '/request-passport-screen';
  static const argumentApartmentRequestsApiModel = 'apartmentRequestsApiModel';
  static const argumentFromRejected = 'fromRejected';

  static Future<void> open(
      BuildContext context, ApartmentRequestsApiModel apartmentRequestsApiModel,
      {bool fromRejected = false}) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentApartmentRequestsApiModel: apartmentRequestsApiModel,
      argumentFromRejected: fromRejected,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestPassportBloc>(
      create: (context) => RequestPassportBloc(RequestPassportRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentRequestsApiManger: ApartmentRequestsApiManger(dioApiManager, context),
      )),
      child: RequestPassportScreenWithBloc(
          apartmentRequestsApiModel(context), closeAfterUpdate(context)),
    );
  }

  ApartmentRequestsApiModel apartmentRequestsApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[RequestPassportScreen.argumentApartmentRequestsApiModel]
          as ApartmentRequestsApiModel;
  bool closeAfterUpdate(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[RequestPassportScreen.argumentFromRejected] as bool;
}

class RequestPassportScreenWithBloc extends BaseStatefulScreenWidget {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;
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
  List<GuestsRequestModel> guestList = [];
  bool haveUpdate = false;
  @override
  void initState() {
    guestList = widget.apartmentRequestsApiModel.guestsReq.toList();
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
          } else if (state is UpdateGuestRequestInfoState) {
            haveUpdate = true;
            _updateList(state.oldData, state.newData);
          } else if (state is UpdateGuestListSuccessfullyState) {
            showFeedbackMessage(state.message);
            widget.apartmentRequestsApiModel.expireReq = state.expiredDate;
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
                  ...guestList
                      .map((e) => TenantWidget(
                            canEdit:
                                widget.fromRejected ? e.isInValidData : false,
                            guestsRequestModel: GuestsRequestModel(
                              guestName: e.guestName,
                              passportImg: e.passportImg,
                              invalidReason: e.invalidReason,
                              validName: e.validName,
                              validPassport: e.validPassport,
                            ),
                            afterEditCallBack:
                                (GuestsRequestModel guestsRequestModel) {
                              _updateGuestData(e, guestsRequestModel);
                            },
                          ))
                      .toList(),
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
      GuestsRequestModel oldData, GuestsRequestModel newData) {
    currentBloc.add(UpdateGuestRequestInfoEvent(oldData, newData));
  }

  bool get allGuestDataIsValid {
    return !guestList.any((element) => (element.passportImg == null));
  }

  void _sendClicked() {
    if (haveUpdate) {
      currentBloc.add(UpdateGuestRequestListApiEvent(
          widget.apartmentRequestsApiModel.requestId, guestList));
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
    RequestDetailsScreen.open(
        context, widget.apartmentRequestsApiModel.requestId);
  }

  // ignore: unused_element
  void _openSecurityDepositPaymentScreen() {
    CompleteYourBookingScreen.open(context, widget.apartmentRequestsApiModel,
        openWithReplacement: true);
  }

  void _updateList(GuestsRequestModel oldData, GuestsRequestModel newData) {
    int i = guestList.indexOf(oldData);
    guestList[i] = newData;
  }

  void _checkFirstTimeUpdate() {
    haveUpdate = guestList.any((element) => element.passportImg == null);
  }
}
