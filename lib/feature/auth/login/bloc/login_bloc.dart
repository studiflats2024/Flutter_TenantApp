import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vivas/apis/models/auth/login/login_fail_response.dart';

import 'package:vivas/apis/models/auth/login/login_successful_response.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/auth/login/bloc/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final BaseLoginRepository loginRepository;
  LoginBloc(this.loginRepository) : super(LoginInitialState()) {
    on<StartWhatsAppSessionEvent>(_startWhatsAppSessionEvent);
    on<ValidatePhonePasswordEvent>(_validateEmailPasswordEvent);
    on<LoginWithPhonePasswordEvent>(_loginWithPhonePasswordEvent);
    on<LoginWithGoogleApiEvent>(_loginWithGoogleApiEvent);
    on<LoginWithAppleEvent>(_loginWithAppleEvent);
    on<SaveTokenDataEvent>(_saveTokenDataEvent);
    on<GetUserInfoApiEvent>(_getUserInfoApiEvent);
    on<SaveUserInfoEvent>(_saveUserInfoEvent);
    on<SetAsLoggedUserEvent>(_setAsLoggedUserEvent);
    on<ForgotPasswordClickedEvent>(_forgotPasswordEvent);
    on<SignUpClickedEventEvent>(_signUpClickedEvent);
  }
  FutureOr<void> _validateEmailPasswordEvent(
      ValidatePhonePasswordEvent event, Emitter<LoginState> emit) {
    if (event.loginFormKey.currentState?.validate() ?? false) {
      event.loginFormKey.currentState?.save();
      emit(PhoneAndPasswordValidatedState());
    } else {
      emit(PhoneAndPasswordNotValidatedState());
    }
  }

  FutureOr<void> _loginWithPhonePasswordEvent(
      LoginWithPhonePasswordEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    emit(await loginRepository.loginWithUserNameAndPasswordApi(
        event.email, event.password));
  }

  FutureOr<void> _loginWithGoogleApiEvent(
      LoginWithGoogleApiEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    emit(await loginRepository.signInWithGoogleApi(event.googleSignInAccount));
  }

  FutureOr<void> _loginWithAppleEvent(
      LoginWithAppleEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    emit(await loginRepository.signInWithAppleApi(event.appleID));
  }

  FutureOr<void> _saveTokenDataEvent(
      SaveTokenDataEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    emit(await loginRepository.savaTokenData(event.loginSuccessfulResponse));
  }

  FutureOr<void> _setAsLoggedUserEvent(
      SetAsLoggedUserEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    emit(await loginRepository.setAsLoggedUser());
  }

  FutureOr<void> _getUserInfoApiEvent(
      GetUserInfoApiEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    emit(await loginRepository.getProfileInfoApi());
  }

  FutureOr<void> _saveUserInfoEvent(
      SaveUserInfoEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    emit(await loginRepository.saveProfileInfo(event.profileInfoApiModel));
  }

  FutureOr<void> _forgotPasswordEvent(
      ForgotPasswordClickedEvent event, Emitter<LoginState> emit) async {
    emit(OpenForgetPasswordScreenState());
  }

  FutureOr<void> _signUpClickedEvent(
      SignUpClickedEventEvent event, Emitter<LoginState> emit) async {
    emit(OpenSignUpScreenState());
  }

  FutureOr<void> _startWhatsAppSessionEvent(
      StartWhatsAppSessionEvent event, Emitter<LoginState> emit) {}
}
