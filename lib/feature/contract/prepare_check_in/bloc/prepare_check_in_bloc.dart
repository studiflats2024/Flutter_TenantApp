import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/contract/prepare_check_in/prepare_check_in_send_model.dart';
import 'package:vivas/apis/models/contract/prepare_check_in/prepare_check_in_successfully_response.dart';
import 'package:vivas/feature/contract/prepare_check_in/bloc/prepare_check_in_repository.dart';

part 'prepare_check_in_event.dart';
part 'prepare_check_in_state.dart';

class PrepareCheckInBloc
    extends Bloc<PrepareCheckInEvent, PrepareCheckInState> {
  final BasePrepareCheckInRepository checkInRepository;
  PrepareCheckInBloc(this.checkInRepository) : super(CheckInInitial()) {
    on<ValidateFormEvent>(_validateFormEvent);
    on<ChangeServiceOptionEvent>(_changeServiceOptionEvent);
    on<SendCheckInEvent>(_sendCheckInEvent);
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<PrepareCheckInState> emit) {
    if (event.formKey.currentState?.validate() ?? false) {
      event.formKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }

  FutureOr<void> _changeServiceOptionEvent(
      ChangeServiceOptionEvent event, Emitter<PrepareCheckInState> emit) {
    emit(ServiceOptionChangedState(event.isYesOptionSelected));
  }

  FutureOr<void> _sendCheckInEvent(
      SendCheckInEvent event, Emitter<PrepareCheckInState> emit) async {
    emit(CheckInLoadingState());
    emit(await checkInRepository.prepareCheckInApi(event.data));
  }
}
