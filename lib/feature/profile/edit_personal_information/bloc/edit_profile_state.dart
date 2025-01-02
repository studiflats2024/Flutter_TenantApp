part of 'edit_profile_bloc.dart';

abstract class EditProfileState {
  List<Object> get props => [];
}

class EditProfileInitialState extends EditProfileState {}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileErrorState extends EditProfileState {
  final String errorMassage;
  final bool isLocalizationKey;
  EditProfileErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage];
}

class BasicDataSuccessfullyUpdatedState extends EditProfileState {
  String message;
  BasicDataSuccessfullyUpdatedState(this.message);
}

class ProfileImageSuccessfullyUpdatedState extends EditProfileState {
  String message;
  ProfileImageSuccessfullyUpdatedState(this.message);
}

class OtpSentState extends EditProfileState {
  OtpSentState();
}

class EditFormValidatedState extends EditProfileState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class EditFormNotValidatedState extends EditProfileState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CurrentEmailSuccessfullyUpdatedState extends EditProfileState {
  UpdateEmailOrPhoneResponse updateEmailResponse;
  CurrentEmailSuccessfullyUpdatedState(this.updateEmailResponse);
}

class CurrentPhoneNumberSuccessfullyUpdatedState extends EditProfileState {
  UpdateEmailOrPhoneResponse updatePhoneResponse;
  CurrentPhoneNumberSuccessfullyUpdatedState(this.updatePhoneResponse);
}

class LocalDataUpdatedSuccessfullyState extends EditProfileState {
  final ProfileInfoApiModel data;
  LocalDataUpdatedSuccessfullyState(this.data);

  @override
  List<Object> get props => [data];
}
