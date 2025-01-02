import 'package:flutter/material.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/complaint/create/create_ticket_send_model.dart';
import 'package:vivas/apis/models/complaint/create/create_ticket_successfully_response.dart';
import 'package:vivas/apis/models/complaint/details/details.api.model.dart';
import 'package:vivas/apis/models/complaint/list/complaint_api_model_list_wrapper.dart';
import 'package:vivas/apis/models/complaint/reply/reply_complaint_send_model.dart';
import 'package:vivas/apis/models/complaint/reply/reply_ticket_successfully_response.dart';
import 'package:vivas/apis/models/complaint/type_list/complaint_type_list_wrapper.dart';

class ComplaintsApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;

  ComplaintsApiManger(this.dioApiManager, this.context);

  Future<void> getTicketsTypesListApi(
      void Function(ComplaintTypeListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getTicketsTypesUrl)
        .then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      ComplaintTypeListWrapper wrapper =
          ComplaintTypeListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getComplaintsListApi(
      void Function(ComplaintApiModelListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getComplaintsListUrl)
        .then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      ComplaintApiModelListWrapper wrapper =
          ComplaintApiModelListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getComplaintsDetailsApi(
      String ticketId,
      void Function(ComplaintDetailsApiModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getComplaintsDetailsUrl,
        queryParameters: {"Ticket_ID": ticketId}).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ComplaintDetailsApiModel wrapper =
          ComplaintDetailsApiModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> createTicketApi(
      CreateTicketSendModel createTicketSendModel,
      void Function(CreateTicketSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.createComplaintsUrl, data: createTicketSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CreateTicketSuccessfullyResponse wrapper =
          CreateTicketSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> replyTicketApi(
      ReplyComplaintSendModel replyTicketSendModel,
      void Function(ReplyTicketSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.replyComplaintsUrl, data: replyTicketSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ReplyTicketSuccessfullyResponse wrapper =
          ReplyTicketSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
