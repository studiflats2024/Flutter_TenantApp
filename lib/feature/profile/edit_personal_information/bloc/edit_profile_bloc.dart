import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/profile/edit_profile/update_email_or_phone/update_email_phone_response.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/profile/profile_screen/bloc/profile_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final BaseProfileRepository profileRepository;

  EditProfileBloc(this.profileRepository) : super(EditProfileInitialState()) {
    on<UpdateBasicDataEvent>(_updateBasicDataEvent);
    on<UpdateProfileImageEvent>(_updateProfileImageEvent);
    on<ValidateFormEvent>(_validateFormEvent);
    on<UpdateEmailEvent>(_updateEmailEvent);
    on<UpdatePhoneNumberEvent>(_updatePhoneNumberEvent);
    on<GetUpdatedLocalDataEvent>(_getUpdatedLocalDataEvent);
  }

  FutureOr<void> _updateBasicDataEvent(
      UpdateBasicDataEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoadingState());
    emit(await profileRepository.updateBasicData(event.fullName, event.about));
  }

  FutureOr<void> _updateProfileImageEvent(
      UpdateProfileImageEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoadingState());
    emit(await profileRepository.updateProfileImage(event.imagePath));
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<EditProfileState> emit) async {
    if (event.editFormKey.currentState?.validate() ?? false) {
      event.editFormKey.currentState?.save();
      emit(EditFormValidatedState());
    } else {
      emit(EditFormNotValidatedState());
    }
  }

  FutureOr<void> _updateEmailEvent(
      UpdateEmailEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoadingState());
    emit(await profileRepository.updateEmail(
        event.currentEmail, event.password, event.newEmail));
  }

  FutureOr<void> _updatePhoneNumberEvent(
      UpdatePhoneNumberEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoadingState());
    emit(await profileRepository.updatePhoneNumber(
        event.currentPhoneNumber, event.password, event.newPhoneNumber));
  }

  FutureOr<void> _getUpdatedLocalDataEvent(
      GetUpdatedLocalDataEvent event, Emitter<EditProfileState> emit) async {
    emit(await profileRepository.getUpdatedLocalData());
  }
}
