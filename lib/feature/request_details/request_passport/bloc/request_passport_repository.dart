import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/UploadPassportRequestModel/passport_request_model.dart';
import 'package:vivas/apis/models/UploadPassportRequestModel/upload_passport_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/guests_request_model.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/update_guests_request_send_model.dart';
import 'package:vivas/feature/request_details/request_passport/bloc/request_passport_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseRequestPassportRepository {
  Future<RequestPassportState> updateRequestGuestsApi(
      String requestId, List<GuestsRequestModel> guestList);

  Future<RequestPassportState> updateRequestGuestsApiV2(
      String requestId, List<PassportRequestModel> guestList);
}

class RequestPassportRepository implements BaseRequestPassportRepository {
  final PreferencesManager preferencesManager;
  final ApartmentRequestsApiManger apartmentRequestsApiManger;

  RequestPassportRepository({
    required this.preferencesManager,
    required this.apartmentRequestsApiManger,
  });

  @override
  Future<RequestPassportState> updateRequestGuestsApi(
      String requestId, List<GuestsRequestModel> guestList) async {
    late RequestPassportState requestPassportState;

    await apartmentRequestsApiManger.updateRequestPassportsApi(
        UpdateGuestsRequestSendModel(
            guestList: guestList,
            requestId: requestId), (updateGuestsRequestResponse) {
      requestPassportState = UpdateGuestListSuccessfullyState(
          updateGuestsRequestResponse.message,
          updateGuestsRequestResponse.updatedExpiredDate);
    }, (errorApiModel) {
      requestPassportState = RequestPassportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestPassportState;
  }

  @override
  Future<RequestPassportState> updateRequestGuestsApiV2(
      String requestId, List<PassportRequestModel> guestList) async {
    late RequestPassportState requestPassportState;


    await apartmentRequestsApiManger.updateRequestPassportsApiV2(
        UploadRequestModel(
            guestList: guestList,
            requestId: requestId), () {
      requestPassportState = const UpdateGuestListSuccessfullyStateV2(
          "Successfully uploaded, Please wait us to review passports",);
    }, (errorApiModel) {
      requestPassportState = RequestPassportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return requestPassportState;
  }
}
