import 'package:vivas/apis/managers/chat_api_manger.dart';
import 'package:vivas/apis/managers/file_api_mangers.dart';
import 'package:vivas/apis/models/chat/send_message/chat_message_send_model.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/apis/models/upload_file/send_upload_file_model.dart';
import 'package:vivas/feature/contact_support/bloc/contact_support_bloc.dart';
import 'package:vivas/feature/contact_support/model/chat_message_ui_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseContactSupportRepository {
  Future<ContactSupportState> getCommonFaqListApi();
  Future<ContactSupportState> getChatListApi(int pageNumber);
  Future<ContactSupportState> getChatBootQuestionsApi();
  Future<ContactSupportState> getChatHistoryApi(String chatUUID);
  Future<ContactSupportState> startNewChatApi(String? aptUUID);
  Future<ContactSupportState> sendChatMessageApi(
      ChatMessageSendModel chatMessageSendModel);
  Future<ContactSupportState> uploadAttachmentChatApi(String attachmentUri);
}

class ContactSupportRepository implements BaseContactSupportRepository {
  final PreferencesManager preferencesManager;
  final ChatApiManger chatApiManger;
  final UploadFileApiManager uploadFileApiManager;

  ContactSupportRepository({
    required this.preferencesManager,
    required this.uploadFileApiManager,
    required this.chatApiManger,
  });

  @override
  Future<ContactSupportState> getCommonFaqListApi() async {
    late ContactSupportState contactSupportState;
    await chatApiManger.getChatFaqApi((fAQListWrapper) {
      contactSupportState = CommonFaqListLoadedState(fAQListWrapper.data);
    }, (errorApiModel) {
      contactSupportState = ContactSupportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return contactSupportState;
  }

  @override
  Future<ContactSupportState> getChatListApi(int pageNumber) async {
    late ContactSupportState contactSupportState;
    await chatApiManger.getChatListApi(
        PagingListSendModel(pageNumber: pageNumber), (chatHistory) {
      contactSupportState =
          ChatHistoryLoadedState(chatHistory.data, chatHistory.pagingInfo);
    }, (errorApiModel) {
      contactSupportState = ContactSupportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return contactSupportState;
  }

  @override
  Future<ContactSupportState> getChatBootQuestionsApi() async {
    late ContactSupportState contactSupportState;
    await chatApiManger.getChatBootQuestApi((chatChatBootQuestionWrapper) {
      contactSupportState =
          ChatBootQuestionListLoadedState(chatChatBootQuestionWrapper.data);
    }, (errorApiModel) {
      contactSupportState = ContactSupportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return contactSupportState;
  }

  @override
  Future<ContactSupportState> getChatHistoryApi(String chatUUID) async {
    late ContactSupportState contactSupportState;
    await chatApiManger.getChatHistoryApi(chatUUID, (chatHistoryWrapper) {
      contactSupportState = ChatMessageLoadedState(chatHistoryWrapper.data
          .map(ChatMessageUiModel.fromChatMessageApiModel)
          .toList());
    }, (errorApiModel) {
      contactSupportState = ContactSupportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return contactSupportState;
  }

  @override
  Future<ContactSupportState> startNewChatApi(String? aptUUID) async {
    late ContactSupportState contactSupportState;
    await chatApiManger.startNewChatApi(aptUUID,
        (startChatSuccessfullyResponse) {
      contactSupportState = StartNewChatSuccessfully(
          startChatSuccessfullyResponse.message,
          startChatSuccessfullyResponse.chatUUID);
    }, (errorApiModel) {
      contactSupportState = ContactSupportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return contactSupportState;
  }

  @override
  Future<ContactSupportState> sendChatMessageApi(
      ChatMessageSendModel chatMessageSendModel) async {
    late ContactSupportState contactSupportState;
    await chatApiManger.sendMessagesChatApi(chatMessageSendModel,
        (chatMessageSuccessfullyResponse) {
      contactSupportState = SendMessageChatSuccessfully(
          ChatMessageUiModel.fromChatMessageApiModel(
              chatMessageSuccessfullyResponse.chatMessageApiModel));
    }, (errorApiModel) {
      contactSupportState = ContactSupportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return contactSupportState;
  }

  @override
  Future<ContactSupportState> uploadAttachmentChatApi(
      String attachmentUri) async {
    late ContactSupportState contactSupportState;
    await uploadFileApiManager.uploadFile(
        SendUploadFileModel(imagePath: attachmentUri), (uploadFileResponse) {
      contactSupportState =
          UploadAttachmentSuccessfully(uploadFileResponse.filePath);
    }, (errorApiModel) {
      contactSupportState = ContactSupportErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return contactSupportState;
  }
}
