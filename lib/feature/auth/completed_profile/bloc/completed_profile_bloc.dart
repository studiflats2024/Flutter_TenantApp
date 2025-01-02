import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/auth/login/login_successful_response.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/auth/completed_profile/bloc/completed_profile_repository.dart';

part 'completed_profile_event.dart';
part 'completed_profile_state.dart';

class CompletedProfileBloc
    extends Bloc<CompletedProfileEvent, CompletedProfileState> {
  final BaseCompletedProfiledRepository completedProfiledRepository;
  CompletedProfileBloc(this.completedProfiledRepository)
      : super(CompletedProfileInitial()) {
    on<ValidateFormEvent>(_validateFormEvent);
    on<SaveTokenDataEvent>(_saveTokenDataEvent);
    on<GetUserInfoApiEvent>(_getUserInfoApiEvent);
    on<SaveUserInfoEvent>(_saveUserInfoEvent);
    on<SetAsLoggedUserEvent>(_setAsLoggedUserEvent);
    on<CompletedProfileInfoApiEvent>(_completedProfileInfoApiEvent);
  }
  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<CompletedProfileState> emit) {
    if (event.formKey.currentState?.validate() ?? false) {
      event.formKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }

  FutureOr<void> _completedProfileInfoApiEvent(
      CompletedProfileInfoApiEvent event,
      Emitter<CompletedProfileState> emit) async {
    emit(CompletedProfileLoadingState());
    CompletedProfileState completedProfileState = await completedProfiledRepository.completedProfileInfoApi(
      birthday: event.birthday,
      email: event.email,
      genderKey: event.genderKey,
      nationality: event.nationality,
      mobileNumber: event.mobileNumber,
      uuid: event.uuid,
      fromSocial: event.fromSocial,
    );
    emit(completedProfileState);
  }

  FutureOr<void> _saveTokenDataEvent(
      SaveTokenDataEvent event, Emitter<CompletedProfileState> emit) async {
    emit(CompletedProfileLoadingState());
    emit(await completedProfiledRepository.savaTokenData(event.loginSuccessfulResponse));
  }

  FutureOr<void> _setAsLoggedUserEvent(
      SetAsLoggedUserEvent event, Emitter<CompletedProfileState> emit) async {
    emit(CompletedProfileLoadingState());
    emit(await completedProfiledRepository.setAsLoggedUser());
  }

  FutureOr<void> _getUserInfoApiEvent(
      GetUserInfoApiEvent event, Emitter<CompletedProfileState> emit) async {
    emit(CompletedProfileLoadingState());
    emit(await completedProfiledRepository.getProfileInfoApi());
  }

  FutureOr<void> _saveUserInfoEvent(
      SaveUserInfoEvent event, Emitter<CompletedProfileState> emit) async {
    emit(CompletedProfileLoadingState());
    emit(await completedProfiledRepository.saveProfileInfo(event.profileInfoApiModel));
  }
}
