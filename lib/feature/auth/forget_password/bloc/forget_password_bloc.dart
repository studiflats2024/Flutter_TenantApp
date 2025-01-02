import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/auth/forget_password/forget_password_successful_response.dart';
import 'package:vivas/feature/auth/forget_password/bloc/forget_password_repository.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final BaseForgetPasswordRepository forgetPasswordRepository;

  ForgetPasswordBloc(this.forgetPasswordRepository)
      : super(ForgetPasswordInitial()) {
    on<ValidateFormEvent>(_validatePhoneNumberEvent);
    on<SendRequestOTPEvent>(_sendRequestOTPEvent);
    on<ResetPasswordApiEvent>(_resetPasswordApiEvent);
    on<ResetPasswordApiEventV2>(_resetPasswordApiEventV2);
  }

  FutureOr<void> _validatePhoneNumberEvent(
      ValidateFormEvent event, Emitter<ForgetPasswordState> emit) {
    if (event.userNameFormKey.currentState?.validate() ?? false) {
      event.userNameFormKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }

  FutureOr<void> _sendRequestOTPEvent(
      SendRequestOTPEvent event, Emitter<ForgetPasswordState> emit) async {
    emit(ForgetPasswordLoadingState());
    emit(await forgetPasswordRepository.requestOTPApi(event.userName));
  }

  FutureOr<void> _resetPasswordApiEvent(
      ResetPasswordApiEvent event, Emitter<ForgetPasswordState> emit) async {
    emit(ForgetPasswordLoadingState());
    emit(await forgetPasswordRepository.resetPasswordApi(
        event.userName, event.token, event.password));
  }

  FutureOr<void> _resetPasswordApiEventV2(
      ResetPasswordApiEventV2 event, Emitter<ForgetPasswordState> emit) async {
    emit(ForgetPasswordLoadingState());
    emit(await forgetPasswordRepository.resetPasswordApiV2(
        event.userName, event.token, event.password));
  }
}
