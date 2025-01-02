import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/feature/make_waiting_request/bloc/make_waiting_request_repository.dart';
import 'package:vivas/feature/make_waiting_request/model/waiting_request_ui_model.dart';

part 'make_waiting_request_event.dart';
part 'make_waiting_request_state.dart';

class MakeWaitingRequestBloc
    extends Bloc<MakeWaitingRequestEvent, MakeWaitingRequestState> {
  final BaseMakeWaitingRequestRepository makeWaitingRequestRepository;
  MakeWaitingRequestBloc(this.makeWaitingRequestRepository)
      : super(MakeWaitingRequestInitial()) {
    on<ValidateFormEvent>(_validateFormEvent);
    on<SendRequestApiEvent>(_sendRequestApiEvent);
    on<ChangeNumberOfGuestEvent>(_changeNumberOfGuestEvent);
    on<ChangeStartDateEvent>(_changeStartDateEvent);
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<MakeWaitingRequestState> emit) {
    if (event.formKey.currentState?.validate() ?? false) {
      event.formKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }

  FutureOr<void> _sendRequestApiEvent(
      SendRequestApiEvent event, Emitter<MakeWaitingRequestState> emit) async {
    emit(MakeWaitingRequestLoadingState());
    emit(await makeWaitingRequestRepository
        .sendRequestApi(event.requestUiModel));
  }

  FutureOr<void> _changeNumberOfGuestEvent(
      ChangeNumberOfGuestEvent event, Emitter<MakeWaitingRequestState> emit) {
    emit(ChangeNumberOfGuestState(event.numberOfGuest));
  }

  FutureOr<void> _changeStartDateEvent(
      ChangeStartDateEvent event, Emitter<MakeWaitingRequestState> emit) {
    emit(StartDateChangedState(event.startDate));
  }
}
