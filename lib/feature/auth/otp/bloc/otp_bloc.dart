import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/feature/auth/otp/bloc/otp_repository.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final BaseOtpRepository otpRepository;

  OtpBloc(this.otpRepository) : super(OtpInitial()) {
    on<ValidateOTPEvent>(_validateOTPEvent);
    on<SendRequestOTPAgainEvent>(_sendRequestOTPAgainEvent);
    on<CheckOTPWithApiEvent>(_checkOTPWithApiEvent);
  }

  FutureOr<void> _validateOTPEvent(
      ValidateOTPEvent event, Emitter<OtpState> emit) {
    if (event.otpFormKey.currentState?.validate() ?? false) {
      event.otpFormKey.currentState?.save();
      emit(OTPValidatedState());
    } else {
      emit(OTPNotValidatedState());
    }
  }

  FutureOr<void> _sendRequestOTPAgainEvent(
      SendRequestOTPAgainEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    emit(await otpRepository.requestOTPAgainApi(event.uuid));
  }

  FutureOr<void> _checkOTPWithApiEvent(
      CheckOTPWithApiEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    emit(await otpRepository.checkOTPApi(event.uuid, event.otpCode));
  }
}
