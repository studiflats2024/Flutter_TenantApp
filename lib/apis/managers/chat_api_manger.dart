import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/chat/chat_boot_question/chat_chat_boot_question_wrapper.dart';
import 'package:vivas/apis/models/chat/chat_messages/chat_messages_wrapper.dart';
import 'package:vivas/apis/models/chat/chat_list/chat_list_wrapper.dart';
import 'package:vivas/apis/models/chat/send_message/chat_message_send_model.dart';
import 'package:vivas/apis/models/chat/send_message/chat_message_successfully_response.dart';
import 'package:vivas/apis/models/chat/start_chat/start_chat_successfully_response.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';

class ChatApiManger {
  final DioApiManager dioApiManager;
  late final bool isDowned;
  final BuildContext context;
  ChatApiManger(this.dioApiManager, this.context);
  var preferencesManager = GetIt.I<PreferencesManager>();

  Future<void> getChatFaqApi(Function(FAQListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dioUnauthorized
        .get(ApiKeys.getChatFAQUrl)
        .then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      FAQListWrapper wrapper = FAQListWrapper.fromJson(extractedData);

      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getChatListApi(
      PagingListSendModel pagingListSendModel,
      void Function(ChatListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getChatListUrl,
            queryParameters: pagingListSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ChatListWrapper wrapper = ChatListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getChatHistoryApi(
      String chatId,
      void Function(ChatMessagesWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(
      ApiKeys.getChatMessagesUrl,
      queryParameters: {"Chat_ID": chatId},
    ).then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      ChatMessagesWrapper wrapper = ChatMessagesWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getChatBootQuestApi(
      void Function(ChatChatBootQuestionWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getChatBootQuestUrl)
        .then((response) async {
      List<dynamic> extractedData = response.data as List<dynamic>;
      ChatChatBootQuestionWrapper wrapper =
          ChatChatBootQuestionWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> startNewChatApi(
      String? aptID,
      void Function(StartChatSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.post(ApiKeys.startNewChatUrl, queryParameters: {
      if (aptID != null) "Apt_ID": aptID,
    }).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      StartChatSuccessfullyResponse wrapper =
          StartChatSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> sendMessagesChatApi(
      ChatMessageSendModel sendModel,
      void Function(ChatMessageSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.sendMessagesChatUrl, data: sendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ChatMessageSuccessfullyResponse wrapper =
          ChatMessageSuccessfullyResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }
}
