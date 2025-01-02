import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/profile/profile_info_api_model.dart';
import 'package:vivas/feature/profile/profile_screen/bloc/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, GetProfileState> {
  final BaseProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(GetProfileInitialState()) {
    on<GetProfileData>(_getProfileDataEvent);
    on<LogoutClickedEvent>(_logoutClickedEvent);
    on<DeleteAccountClickedEvent>(_deleteAccountClickedEvent);
  }

  FutureOr<void> _getProfileDataEvent(
      GetProfileData event, Emitter<GetProfileState> emit) async {
    emit(GetProfileLoadingState());
    emit(await profileRepository.getProfileData());
  }

  Future<FutureOr<void>> _logoutClickedEvent(
      LogoutClickedEvent event, Emitter<GetProfileState> emit) async {
    emit(GetProfileLoadingState());
    emit(await profileRepository.logout());
  }

  Future<FutureOr<void>> _deleteAccountClickedEvent(
      DeleteAccountClickedEvent event, Emitter<GetProfileState> emit) async {
    emit(GetProfileLoadingState());
    emit(await profileRepository.deleteAccount());
  }
}
