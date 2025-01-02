import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/make_waiting_request/waiting_requests_send_model.dart';
import 'package:vivas/feature/make_waiting_request/bloc/make_waiting_request_bloc.dart';
import 'package:vivas/feature/make_waiting_request/model/waiting_request_ui_model.dart';

abstract class BaseMakeWaitingRequestRepository {
  Future<MakeWaitingRequestState> sendRequestApi(
      WaitingRequestUiModel requestUiModel);
}

class MakeWaitingRequestRepository implements BaseMakeWaitingRequestRepository {
  final ApartmentRequestsApiManger apartmentRequestsApiManger;
  MakeWaitingRequestRepository(this.apartmentRequestsApiManger);

  @override
  Future<MakeWaitingRequestState> sendRequestApi(
      WaitingRequestUiModel requestUiModel) async {
    late MakeWaitingRequestState makeWaitingRequestState;

    await apartmentRequestsApiManger.createWaitingRequestsApi(
        WaitingRequestsSendModel(
          startDate: requestUiModel.startDate!,
          endDate: requestUiModel.endDate!,
          numberOfGuests: requestUiModel.numberOfGuests!,
          city: requestUiModel.city!,
          rentFees: requestUiModel.rentFees!,
          tellMore: requestUiModel.tellMore!,
        ), (makeWaitingRequestResponse) {
      makeWaitingRequestState =
          SendRequestSuccessfullyState(makeWaitingRequestResponse.message);
    }, (errorApiModel) {
      makeWaitingRequestState = MakeWaitingRequestErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return makeWaitingRequestState;
  }
}
