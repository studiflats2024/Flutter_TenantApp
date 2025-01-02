part of 'contact_support_bloc.dart';

sealed class ContactSupportState extends Equatable {
  const ContactSupportState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class ContactSupportInitial extends ContactSupportState {}

class ContactSupportLoadingState extends ContactSupportState {}

class ChatMessageLoadingState extends ContactSupportState {}

class ContactSupportLoadingAsPagingState extends ContactSupportState {}

class ContactSupportErrorState extends ContactSupportState {
  final String errorMassage;
  final bool isLocalizationKey;
  const ContactSupportErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class CommonFaqListLoadedState extends ContactSupportState {
  final List<FAQModel> list;

  const CommonFaqListLoadedState(this.list);
  @override
  List<Object> get props => [list];
}

class ChatBootQuestionListLoadedState extends ContactSupportState {
  final List<ChatBootQuestionModel> list;

  const ChatBootQuestionListLoadedState(this.list);
  @override
  List<Object> get props => [list];
}

class ChatMessageLoadedState extends ContactSupportState {
  final List<ChatMessageUiModel> list;

  const ChatMessageLoadedState(this.list);
  @override
  List<Object> get props => [list];
}

class FormValidatedState extends ContactSupportState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class FormNotValidatedState extends ContactSupportState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChatHistoryLoadedState extends ContactSupportState {
  final List<ChatItemModel> list;
  final MetaModel pagingInfo;

  const ChatHistoryLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list, pagingInfo];
}

class StartNewChatSuccessfully extends ContactSupportState {
  final String message;
  final String chatUUID;

  const StartNewChatSuccessfully(this.message, this.chatUUID);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendMessageChatSuccessfully extends ContactSupportState {
  final ChatMessageUiModel chatMessageUiModel;

  const SendMessageChatSuccessfully(this.chatMessageUiModel);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class UploadAttachmentSuccessfully extends ContactSupportState {
  final String filePath;

  const UploadAttachmentSuccessfully(this.filePath);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class BotQuestionClickedState extends ContactSupportState {
  final ChatBootQuestionModel chatBootQuestionModel;
  const BotQuestionClickedState(this.chatBootQuestionModel);
  @override
  List<Object> get props => [chatBootQuestionModel];
}
