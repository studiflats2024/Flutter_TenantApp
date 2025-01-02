import 'package:vivas/apis/managers/complaints_api_manger.dart';
import 'package:vivas/apis/models/complaint/create/create_ticket_send_model.dart';
import 'package:vivas/apis/models/complaint/reply/reply_complaint_send_model.dart';
import 'package:vivas/feature/complaints/bloc/complaints_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseComplaintsRepository {
  Future<ComplaintsState> getTicketsTypesListApi();
  Future<ComplaintsState> getComplaintsListApi();
  Future<ComplaintsState> getComplaintsDetailsApi(String ticketId);
  Future<ComplaintsState> createTicketApi(
      CreateTicketSendModel createTicketSendModel);
  Future<ComplaintsState> replyTicketApi(
      ReplyComplaintSendModel replyTicketSendModel);
}

class ComplaintsRepository implements BaseComplaintsRepository {
  final PreferencesManager preferencesManager;
  final ComplaintsApiManger complaintsApiManger;

  ComplaintsRepository({
    required this.preferencesManager,
    required this.complaintsApiManger,
  });

  @override
  Future<ComplaintsState> getComplaintsListApi() async {
    late ComplaintsState complaintsState;
    await complaintsApiManger.getComplaintsListApi(
        (complaintApiModelListWrapper) {
      complaintsState =
          ComplaintsListLoadedState(complaintApiModelListWrapper.data);
    }, (errorApiModel) {
      complaintsState = ComplaintsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return complaintsState;
  }

  @override
  Future<ComplaintsState> createTicketApi(
      CreateTicketSendModel createTicketSendModel) async {
    late ComplaintsState complaintsState;
    await complaintsApiManger.createTicketApi(createTicketSendModel,
        (createTicketSuccessfullyResponse) {
      complaintsState = ComplaintsAddSuccessfullyState(
          createTicketSuccessfullyResponse.message);
    }, (errorApiModel) {
      complaintsState = ComplaintsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return complaintsState;
  }

  @override
  Future<ComplaintsState> getComplaintsDetailsApi(String ticketId) async {
    late ComplaintsState complaintsState;
    await complaintsApiManger.getComplaintsDetailsApi(ticketId,
        (complaintDetailsApiModel) {
      complaintsState = ComplaintsDetailsLoadedState(complaintDetailsApiModel);
    }, (errorApiModel) {
      complaintsState = ComplaintsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return complaintsState;
  }

  @override
  Future<ComplaintsState> getTicketsTypesListApi() async {
    late ComplaintsState complaintsState;
    await complaintsApiManger.getTicketsTypesListApi(
        (complaintTypeListWrapper) {
      complaintsState =
          ComplaintsTypeLoadedState(complaintTypeListWrapper.data);
    }, (errorApiModel) {
      complaintsState = ComplaintsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return complaintsState;
  }

  @override
  Future<ComplaintsState> replyTicketApi(
      ReplyComplaintSendModel replyTicketSendModel) async {
    late ComplaintsState complaintsState;
    await complaintsApiManger.replyTicketApi(replyTicketSendModel,
        (replyTicketSuccessfullyResponse) {
      complaintsState = ComplaintsAddSuccessfullyState(
          replyTicketSuccessfullyResponse.message);
    }, (errorApiModel) {
      complaintsState = ComplaintsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return complaintsState;
  }
}
