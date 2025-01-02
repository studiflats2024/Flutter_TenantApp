part of 'completed_profile_bloc.dart';

abstract class CompletedProfileState extends Equatable {
  const CompletedProfileState();

  @override
  List<Object> get props => [];
}

class CompletedProfileInitial extends CompletedProfileState {}

class CompletedProfileLoadingState extends CompletedProfileState {}

class CompletedProfileErrorState extends CompletedProfileState {
  final String errorMassage;
  final bool isLocalizationKey;

  const CompletedProfileErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class FormValidatedState extends CompletedProfileState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class FormNotValidatedState extends CompletedProfileState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CompletedProfileInfoSuccessfullyState extends CompletedProfileState {
  final LoginSuccessfulResponse loginSuccessfulResponse;
  const CompletedProfileInfoSuccessfullyState(this.loginSuccessfulResponse);
  @override
  List<Object> get props => [identityHashCode(this)];
}


class SaveTokenDataSuccessfullyState extends CompletedProfileState {
  final LoginSuccessfulResponse loginSuccessfulResponse;
  const SaveTokenDataSuccessfullyState(this.loginSuccessfulResponse);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class OpenHomeScreenState extends CompletedProfileState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ProfileInfoLoadedState extends CompletedProfileState {
  final ProfileInfoApiModel profileInfoApiModel;

  ProfileInfoLoadedState(this.profileInfoApiModel);
}

class SaveProfileInfoSuccessfullyState extends CompletedProfileState {
  SaveProfileInfoSuccessfullyState();
}
