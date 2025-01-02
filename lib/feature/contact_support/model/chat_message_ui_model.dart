import 'package:vivas/apis/models/chat/chat_boot_question/chat_boot_question_model.dart';
import 'package:vivas/apis/models/chat/chat_messages/chat_message_api_model.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ChatMessageUiModel {
  final String messageId;
  final String? userName;
  final String? userPhoto;
  final String? msgBody;
  final String? msgAttachment;
  final DateTime? sendTime;
  final MessageType messageType;
  final ChatBootQuestionModel? chatBootQuestionModel;

  ChatMessageUiModel({
    required this.messageId,
    required this.messageType,
    this.userName,
    this.userPhoto,
    this.msgBody,
    this.msgAttachment,
    this.chatBootQuestionModel,
    this.sendTime,
  });

  bool get isBotQuestion => messageType == MessageType.botQuestion;
  factory ChatMessageUiModel.fromChatMessageApiModel(
          ChatMessageApiModel model) =>
      ChatMessageUiModel(
        messageId: model.messageId,
        userName: model.userName,
        userPhoto: model.userPhoto,
        msgBody: model.msgBody,
        msgAttachment: model.msgAttachment,
        sendTime: model.sendTime,
        messageType: model.isMobile ? MessageType.customer : MessageType.agent,
      );
  factory ChatMessageUiModel.fromChatBootQuestionModel(
          ChatBootQuestionModel model) =>
      ChatMessageUiModel(
        messageId: model.id,
        msgBody: model.quest,
        messageType: MessageType.botQuestion,
        chatBootQuestionModel: model,
      );

  factory ChatMessageUiModel.fromChatBootQuestionAnswer(
          ChatBootQuestionModel model) =>
      ChatMessageUiModel(
        messageId: model.id,
        msgBody: model.questAnswer,
        chatBootQuestionModel: model,
        messageType: MessageType.botAnswer,
      );

  factory ChatMessageUiModel.startChatMessage(
          String? Function(String localizationKey) translate) =>
      ChatMessageUiModel(
        messageId: "0",
        msgBody: translate(LocalizationKeys.helloHowCanIHelpYou)!,
        sendTime: DateTime.now(),
        messageType: MessageType.agent,
      );
}

enum MessageType {
  agent,
  botQuestion,
  botAnswer,
  customer,
}
