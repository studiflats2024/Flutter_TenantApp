part of 'contact_support_bloc.dart';

sealed class ContactSupportEvent extends Equatable {
  const ContactSupportEvent();

  @override
  List<Object> get props => [];
}

class GetCommonFaqApiEvent extends ContactSupportEvent {
  const GetCommonFaqApiEvent();
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ValidateFormEvent extends ContactSupportEvent {
  final GlobalKey<FormState> formKey;
  const ValidateFormEvent(this.formKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetChatListApiEvent extends ContactSupportEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  const GetChatListApiEvent(this.pageNumber, this.isSwipeToRefresh);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}

class GetChatBootQuestionsApiEvent extends ContactSupportEvent {
  const GetChatBootQuestionsApiEvent();
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetChatHistoryApiEvent extends ContactSupportEvent {
  final String chatUUID;
  const GetChatHistoryApiEvent(this.chatUUID);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class StartNewChatApiEvent extends ContactSupportEvent {
  final String? aptUUID;
  const StartNewChatApiEvent(this.aptUUID);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendMessageApiEvent extends ContactSupportEvent {
  final ChatMessageSendModel chatMessageSendModel;
  const SendMessageApiEvent(this.chatMessageSendModel);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class BotQuestionClickedEvent extends ContactSupportEvent {
  final ChatBootQuestionModel chatBootQuestionModel;
  const BotQuestionClickedEvent(this.chatBootQuestionModel);
  @override
  List<Object> get props => [chatBootQuestionModel];
}

class UploadAttachmentApiEvent extends ContactSupportEvent {
  final String filePath;
  const UploadAttachmentApiEvent(this.filePath);
  @override
  List<Object> get props => [identityHashCode(this)];
}
