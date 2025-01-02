import 'package:get_it/get_it.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/make_request/apartment_request_send_model_v2.dart';
import 'package:vivas/apis/models/apartment_requests/make_request/apartment_requests_send_model.dart';
import 'package:vivas/feature/make_request/bloc/make_request_bloc.dart';
import 'package:vivas/feature/make_request/model/request_ui_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseMakeRequestRepository {
  Future<MakeRequestState> sendRequestApi(RequestUiModel requestUiModel);

  Future<MakeRequestState> sendRequestApiV2(RequestUiModel requestUiModel,bool isSelectedFull);
}

class MakeRequestRepository implements BaseMakeRequestRepository {
  final ApartmentRequestsApiManger apartmentRequestsApiManger;

  MakeRequestRepository(this.apartmentRequestsApiManger);

  @override
  Future<MakeRequestState> sendRequestApi(RequestUiModel requestUiModel) async {
    late MakeRequestState makeRequestState;

    await apartmentRequestsApiManger.createRequestsApi(
        ApartmentRequestsSendModel(
          aptUUID: requestUiModel.aptUUID,
          startDate: requestUiModel.startDate!,
          endDate: requestUiModel.endDate!,
          numberOfGuests: requestUiModel.numberOfGuests,
          nameOfGuests: requestUiModel.nameOfGuests,
          role: requestUiModel.role!,
          brokerCode: requestUiModel.brokerCode!,
          purposeOfComingToGermany: requestUiModel.purposeOfComingToGermany!,
        ), (makeRequestResponse) {
      makeRequestState = SendRequestSuccessfullyState(
          makeRequestResponse.message, makeRequestResponse.requestId ?? "");
    }, (errorApiModel) {
      makeRequestState = MakeRequestErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return makeRequestState;
  }

  @override
  Future<MakeRequestState> sendRequestApiV2(
      RequestUiModel requestUiModel ,bool isSelectedFull) async {
    late MakeRequestState makeRequestState;

    List<BookingGuest> guests = [];
    var preferencesManager = GetIt.I<PreferencesManager>();
    String mobile = await preferencesManager.getMobileNumber() ?? "";
    String email = await preferencesManager.getEmail() ?? "";
    for (var entry in requestUiModel.roomsId.entries) {
      if(entry.value["bed_ID"] ==  requestUiModel.chooseWhereStay  ){
        if(guests.isNotEmpty) {
          guests.insert(0, BookingGuest(
              roomId: entry.value["room_ID"] ?? "",
              bedID: entry.value["bed_ID"] ?? "",
              apartmentID: requestUiModel.aptUUID,
              guestName: entry.value["guest_Name"] ?? "",
              guestWaNumber: mobile,
              guestEmail: email));
        }else{
          guests.add(BookingGuest(
              roomId: entry.value["room_ID"] ?? "",
              bedID: entry.value["bed_ID"] ?? "",
              apartmentID: requestUiModel.aptUUID,
              guestName: entry.value["guest_Name"] ?? "",
              guestWaNumber: mobile ,
              guestEmail: email));
        }
      }else{
        guests.add(BookingGuest(
            roomId: entry.value["room_ID"] ?? "",
            bedID: entry.value["bed_ID"] ?? "",
            apartmentID: requestUiModel.aptUUID,
            guestName: entry.value["guest_Name"] ?? "",
            guestWaNumber: entry.value["guest_WA_No"] ?? "",
            guestEmail: entry.value["guest_Email"] ?? ""));
      }
    }
    await apartmentRequestsApiManger.createRequestsApiV2(
        ApartmentRequestsSendModelV2(
          bookingApartmentId: requestUiModel.aptUUID,
          bookingRoomId: requestUiModel.roomID,
          bookingBedId: requestUiModel.bedID,
          bookingStartDate: requestUiModel.startDate!,
          bookingEndDate: requestUiModel.endDate!,
          bookingGuests: guests,
          bookingGuestProfession: requestUiModel.role,
          bookingAgentCode: requestUiModel.brokerCode ?? "",
          bookingUnvWpName: requestUiModel.universityName!,
          fullApartment: isSelectedFull,
        ), (makeRequestResponse) {
      makeRequestState = SendRequestSuccessfullyState(
          makeRequestResponse.message, makeRequestResponse.requestId ?? "");
    }, (errorApiModel) {
      makeRequestState = MakeRequestErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return makeRequestState;
  }
}
