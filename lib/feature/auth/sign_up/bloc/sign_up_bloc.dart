import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vivas/apis/models/auth/auth_successful_response.dart';
import 'package:vivas/apis/models/auth/login/login_fail_response.dart';
import 'package:vivas/apis/models/auth/login/login_successful_response.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/auth/sign_up/bloc/sign_up_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final BaseSignUpRepository signUpRepository;

  SignUpBloc(this.signUpRepository) : super(SignUpInitial()) {
    on<ValidateFormEvent>(_validateFormEvent);
    on<SignUpApiEvent>(_signUpApiEvent);
    on<SignUpWithGoogleApiEvent>(_signUpWithGoogleApiEvent);
    on<SignUpWithAppleEvent>(_signUpWithAppleEvent);
    on<SaveTokenDataEvent>(_saveTokenDataEvent);
    on<GetUserInfoApiEvent>(_getUserInfoApiEvent);
    on<SaveUserInfoEvent>(_saveUserInfoEvent);
    on<SetAsLoggedUserEvent>(_setAsLoggedUserEvent);
    on<LoginClickedEventEvent>(_signInClickedEvent);
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<SignUpState> emit) async {
    if (event.signUpFormKey.currentState?.validate() ?? false) {
      event.signUpFormKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }

  FutureOr<void> _signUpApiEvent(
      SignUpApiEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    emit(await signUpRepository.signUpApi(
      event.phoneNumber,
      event.fullName,
      event.password,
    ));
  }

  FutureOr<void> _signUpWithGoogleApiEvent(
      SignUpWithGoogleApiEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    emit(await signUpRepository.signUpWithGoogleApi(event.googleSignInAccount));
  }

  FutureOr<void> _signUpWithAppleEvent(
      SignUpWithAppleEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    emit(await signUpRepository.signUpWithAppleApi(event.appleID));
  }

  FutureOr<void> _saveTokenDataEvent(
      SaveTokenDataEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    emit(await signUpRepository.savaTokenData(event.loginSuccessfulResponse));
  }

  FutureOr<void> _getUserInfoApiEvent(
      GetUserInfoApiEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    emit(await signUpRepository.getProfileInfoApi());
  }

  FutureOr<void> _saveUserInfoEvent(
      SaveUserInfoEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    emit(await signUpRepository.saveProfileInfo(event.profileInfoApiModel));
  }

  FutureOr<void> _setAsLoggedUserEvent(
      SetAsLoggedUserEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    emit(await signUpRepository.setAsLoggedUser());
  }

  FutureOr<void> _signInClickedEvent(
      LoginClickedEventEvent event, Emitter<SignUpState> emit) async {
    emit(OpenSignInScreenState());
  }
}
