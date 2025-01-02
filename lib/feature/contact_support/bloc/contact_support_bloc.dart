import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/chat/chat_boot_question/chat_boot_question_model.dart';
import 'package:vivas/apis/models/chat/chat_list/chat_item_model.dart';
import 'package:vivas/apis/models/chat/send_message/chat_message_send_model.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/contact_support/bloc/contact_support_repository.dart';
import 'package:vivas/feature/contact_support/model/chat_message_ui_model.dart';

part 'contact_support_event.dart';
part 'contact_support_state.dart';

class ContactSupportBloc
    extends Bloc<ContactSupportEvent, ContactSupportState> {
  final BaseContactSupportRepository contactSupportRepository;
  ContactSupportBloc(this.contactSupportRepository)
      : super(ContactSupportInitial()) {
    on<GetCommonFaqApiEvent>(_getCommonFaqApiEvent);
    on<GetChatListApiEvent>(_getChatListApiEvent);
    on<GetChatBootQuestionsApiEvent>(_getChatBootQuestionsApiEvent);
    on<GetChatHistoryApiEvent>(_getChatHistoryApiEvent);
    on<StartNewChatApiEvent>(_startNewChatApiEvent);
    on<SendMessageApiEvent>(_sendMessageApiEvent);
    on<ValidateFormEvent>(_validateFormEvent);
    on<BotQuestionClickedEvent>(_botQuestionClickedEvent);
    on<UploadAttachmentApiEvent>(_uploadAttachmentApiEvent);
  }

  FutureOr<void> _getCommonFaqApiEvent(
      GetCommonFaqApiEvent event, Emitter<ContactSupportState> emit) async {
    emit(ContactSupportLoadingState());
    emit(await contactSupportRepository.getCommonFaqListApi());
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<ContactSupportState> emit) {
    if (event.formKey.currentState?.validate() ?? false) {
      event.formKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }

  FutureOr<void> _getChatListApiEvent(
      GetChatListApiEvent event, Emitter<ContactSupportState> emit) async {
    emit(ContactSupportLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? ContactSupportLoadingState()
          : ContactSupportLoadingAsPagingState());
    }
    emit(await contactSupportRepository.getChatListApi(event.pageNumber));
  }

  FutureOr<void> _getChatBootQuestionsApiEvent(
      GetChatBootQuestionsApiEvent event,
      Emitter<ContactSupportState> emit) async {
    emit(ContactSupportLoadingState());
    emit(await contactSupportRepository.getChatBootQuestionsApi());
  }

  FutureOr<void> _getChatHistoryApiEvent(
      GetChatHistoryApiEvent event, Emitter<ContactSupportState> emit) async {
    emit(ContactSupportLoadingState());
    emit(await contactSupportRepository.getChatHistoryApi(event.chatUUID));
  }

  FutureOr<void> _startNewChatApiEvent(
      StartNewChatApiEvent event, Emitter<ContactSupportState> emit) async {
    emit(ContactSupportLoadingState());
    emit(await contactSupportRepository.startNewChatApi(event.aptUUID));
  }

  FutureOr<void> _sendMessageApiEvent(
      SendMessageApiEvent event, Emitter<ContactSupportState> emit) async {
    emit(ChatMessageLoadingState());
    emit(await contactSupportRepository
        .sendChatMessageApi(event.chatMessageSendModel));
  }

  FutureOr<void> _botQuestionClickedEvent(
      BotQuestionClickedEvent event, Emitter<ContactSupportState> emit) {
    emit(BotQuestionClickedState(event.chatBootQuestionModel));
  }

  Future<FutureOr<void>> _uploadAttachmentApiEvent(
      UploadAttachmentApiEvent event, Emitter<ContactSupportState> emit) async {
    emit(ChatMessageLoadingState());
    emit(
        await contactSupportRepository.uploadAttachmentChatApi(event.filePath));
  }
}
