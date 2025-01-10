import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/ApartmentRules/apartment_rules_request.dart';
import 'package:vivas/apis/models/ApartmentRules/apartment_rules_response_model.dart';
import 'package:vivas/apis/models/HandoverProtocols/handover_protocols_model.dart';
import 'package:vivas/apis/models/HandoverProtocols/handover_protocols_request.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/get_requests_send_model.dart';
import 'package:vivas/apis/models/booking/change_check_out_date_model.dart';
import 'package:vivas/apis/models/booking/extend_contract_model.dart';
import 'package:vivas/apis/models/booking/qr_request_model.dart';
import 'package:vivas/apis/models/booking/selfie_request_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/bookings/bloc/apartment_rules_bloc.dart';
import 'package:vivas/feature/bookings/bloc/booking__bloc.dart';
import 'package:vivas/feature/bookings/bloc/bookings_bloc.dart';
import 'package:vivas/feature/bookings/bloc/handover_protocols_bloc.dart';
import 'package:vivas/feature/bookings/bloc/qr_bloc.dart';
import 'package:vivas/feature/bookings/bloc/selfie_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

import '../../../apis/models/apartment_requests/apartment_requests/get_requests_send_model_v2.dart';
import '../../../apis/models/contract/sign_contract/sign_contract_send_model_v2.dart';

abstract class BaseBookingsRepository {
  Future<BookingsState> getExpiredBookingsApi(int pageNumber);

  Future<BookingsState> getExpiredBookingsApiV2(int pageNumber);

  Future<BookingsState> getActiveBookingsApi(int pageNumber);

  Future<BookingsState> getActiveBookingsApiV2(int pageNumber);

  Future<BookingsState> getOffersBookingsApi(int pageNumber);

  Future<BookingsState> getOffersBookingsApiV2(int pageNumber);

  Future<QrState> scanQrCodeBedApi(QrRequestModel qrRequestModel);

  Future<SelfieState> selfieSendImage(SelfieRequestModel selfieRequestModel);

  Future<HandoverProtocolsState> getHandoverProtocols(
      HandoverProtocolsRequest handoverProtocolsRequest);

  Future<HandoverProtocolsState> signHandoverProtocols(
      String requestId, String contractId, String signatureImagePath);

  Future<ApartmentRulesState> getApartmentRules(
      ApartmentRulesRequest apartmentRulesRequest);

  Future<ApartmentRulesState> signApartmentRules(
      String requestId, String contractId, String signatureImagePath);

  Future<BookingsState> checkLoggedIn();

  Future<BookingState> extendContract(ExtendContractModel extendContractModel);
  Future<BookingState> changeCheckOutDate(ChangeCheckOutDateModel model);
}

class BookingsRepository implements BaseBookingsRepository {
  final PreferencesManager preferencesManager;
  final ApartmentRequestsApiManger apartmentRequestsApiManger;

  BookingsRepository({
    required this.preferencesManager,
    required this.apartmentRequestsApiManger,
  });

  @override
  Future<BookingsState> getActiveBookingsApi(int pageNumber) async {
    late BookingsState bookingsState;
    await apartmentRequestsApiManger.getRequestsListApi(
        GetRequestsSendModel(status: true, pageNumber: pageNumber),
        (makeRequestResponse) {
      bookingsState = BookingsActiveLoadedState(
          makeRequestResponse.data, makeRequestResponse.pagingInfo);
    }, (errorApiModel) {
      bookingsState = BookingsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return bookingsState;
  }

  @override
  Future<BookingsState> getActiveBookingsApiV2(int pageNumber) async {
    late BookingsState bookingsState;
    await apartmentRequestsApiManger.getRequestsListApiV2(
        GetRequestsSendModelV2(active: true, pageNumber: pageNumber),
        (makeRequestResponse) {
      bookingsState = BookingsActiveLoadedStateV2(makeRequestResponse.data,
          MetaModel.fromJson(makeRequestResponse.toJson()));
    }, (errorApiModel) {
      bookingsState = BookingsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return bookingsState;
  }

  @override
  Future<BookingsState> getOffersBookingsApiV2(int pageNumber) async {
    late BookingsState bookingsState;
    await apartmentRequestsApiManger.getRequestsListApiV2(
        GetRequestsSendModelV2(offered: true, pageNumber: pageNumber),
        (makeRequestResponse) {
      bookingsState = BookingsOffersLoadedStateV2(makeRequestResponse.data,
          MetaModel.fromJson(makeRequestResponse.toJson()));
    }, (errorApiModel) {
      bookingsState = BookingsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return bookingsState;
  }

  @override
  Future<BookingsState> getExpiredBookingsApi(int pageNumber) async {
    late BookingsState bookingsState;

    await apartmentRequestsApiManger.getRequestsListApi(
        GetRequestsSendModel(status: false, pageNumber: pageNumber),
        (makeRequestResponse) {
      bookingsState = BookingsExpiredLoadedState(
          makeRequestResponse.data, makeRequestResponse.pagingInfo);
    }, (errorApiModel) {
      bookingsState = BookingsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return bookingsState;
  }

  @override
  Future<BookingsState> getExpiredBookingsApiV2(int pageNumber) async {
    late BookingsState bookingsState;

    await apartmentRequestsApiManger.getRequestsListApiV2(
        GetRequestsSendModelV2(pageNumber: pageNumber),
        (makeRequestResponse) {
      bookingsState = BookingsExpiredLoadedStateV2(makeRequestResponse.data,
          MetaModel.fromJson(makeRequestResponse.toJson()));
    }, (errorApiModel) {
      bookingsState = BookingsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return bookingsState;
  }

  @override
  Future<BookingsState> getOffersBookingsApi(int pageNumber) async {
    late BookingsState bookingsState;
    await apartmentRequestsApiManger.getRequestsListApi(
        GetRequestsSendModel(pageNumber: pageNumber), (makeRequestResponse) {
      bookingsState = BookingsOffersLoadedState(
          makeRequestResponse.data, makeRequestResponse.pagingInfo);
    }, (errorApiModel) {
      bookingsState = BookingsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return bookingsState;
  }

  @override
  Future<BookingsState> checkLoggedIn() async {
    late BookingsState bookingsState;

    bool isLoggedIn = await preferencesManager.isLoggedIn();
    if (isLoggedIn) {
      bookingsState = IsLoggedInState();
    } else {
      bookingsState = IsGuestModeState();
    }
    return bookingsState;
  }

  @override
  Future<QrState> scanQrCodeBedApi(QrRequestModel qrRequestModel) async {
    late QrState qrState;
    await apartmentRequestsApiManger.scanQrBed(qrRequestModel, () {
      qrState = QrSuccessScan();
    }, (p0) {
      qrState = QrFailed(p0.message, p0.isMessageLocalizationKey);
    });

    return qrState;
  }

  @override
  Future<SelfieState> selfieSendImage(
      SelfieRequestModel selfieRequestModel) async {
    late SelfieState selfieState;
    await apartmentRequestsApiManger.sendSelfieImage(selfieRequestModel, () {
      selfieState = SelfieSendingSuccess();
    }, (p0) {
      selfieState =
          SelfieSendingException(p0.message, p0.isMessageLocalizationKey);
    });
    return selfieState;
  }

  @override
  Future<HandoverProtocolsState> getHandoverProtocols(
      HandoverProtocolsRequest handoverProtocolsRequest) async {
    late HandoverProtocolsState handoverProtocolsState;
    await apartmentRequestsApiManger
        .getHandoverProtocols(handoverProtocolsRequest,
            (HandoverProtocolsResponseModel handoverProtocolsResponseModel) {
      handoverProtocolsState =
          GetHandoverProtocolsSuccess(handoverProtocolsResponseModel);
    }, (p0) {
      handoverProtocolsState = GetHandoverProtocolsException(
          p0.message, p0.isMessageLocalizationKey);
    });
    return handoverProtocolsState;
  }

  @override
  Future<HandoverProtocolsState> signHandoverProtocols(
      String requestId, String contractId, String signatureImagePath) async {
    late HandoverProtocolsState handoverProtocolsState;
    await apartmentRequestsApiManger.signHandoverProtocols(
        SignContractSendModelV2(
            requestId: requestId,
            contractID: contractId,
            signaturePath: signatureImagePath), (contractWrapper) {
      handoverProtocolsState = SignHandoverProtocolsSuccess(contractWrapper);
    }, (errorApiModel) {
      handoverProtocolsState = SignHandoverProtocolsException(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return handoverProtocolsState;
  }

  @override
  Future<ApartmentRulesState> getApartmentRules(
      ApartmentRulesRequest apartmentRulesRequest) async {
    late ApartmentRulesState apartmentRulesState;
    await apartmentRequestsApiManger.getApartmentRules(apartmentRulesRequest,
        (ApartmentRulesResponseModel apartmentRulesResponseModel) {
      apartmentRulesState =
          GetApartmentRulesSuccess(apartmentRulesResponseModel);
    }, (p0) {
      apartmentRulesState =
          GetApartmentRulesException(p0.message, p0.isMessageLocalizationKey);
    });
    return apartmentRulesState;
  }

  @override
  Future<ApartmentRulesState> signApartmentRules(
      String requestId, String contractId, String signatureImagePath) async {
    late ApartmentRulesState apartmentRulesState;
    await apartmentRequestsApiManger.signHandoverProtocols(
        SignContractSendModelV2(
            requestId: requestId,
            contractID: contractId,
            signaturePath: signatureImagePath), (contractWrapper) {
      apartmentRulesState = SignApartmentRulesSuccess(contractWrapper);
    }, (errorApiModel) {
      apartmentRulesState = SignApartmentRulesException(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return apartmentRulesState;
  }

  @override
  Future<BookingState> extendContract(
      ExtendContractModel extendContractModel) async {
    late BookingState bookingState;
    await apartmentRequestsApiManger.extendContract(
      extendContractModel,
      (data) {
        showFeedbackMessage(data['message']);
        bookingState = ExtendContractSuccessState();
      },
      (errorModel) {
        bookingState = ExtendContractFailedState(errorModel);
      },
    );

    return bookingState;
  }

  @override
  Future<BookingState> changeCheckOutDate(ChangeCheckOutDateModel model) async{
    late BookingState bookingState;
    await apartmentRequestsApiManger.changeCheckOutDate(
      model,
          (data) {
        showFeedbackMessage(data['message']);
        bookingState = ExtendContractSuccessState();
      },
          (errorModel) {
        bookingState = ExtendContractFailedState(errorModel);
      },
    );

    return bookingState;
  }
}
