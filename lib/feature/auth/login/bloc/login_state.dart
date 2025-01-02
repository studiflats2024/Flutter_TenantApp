part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String errorMassage;
  final bool isLocalizationKey;
  LoginErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class PhoneAndPasswordValidatedState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class PhoneAndPasswordNotValidatedState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class LoginFailState extends LoginState {
  final LoginFailResponse loginFailResponse;
  final bool fromSocial;
  LoginFailState(this.loginFailResponse, this.fromSocial);
}

abstract class LoginSuccessfullyState extends LoginState {
  final LoginSuccessfulResponse loginSuccessfulResponse;
  LoginSuccessfullyState(this.loginSuccessfulResponse);
}

class LoginWithPhoneSuccessfullyState extends LoginSuccessfullyState {
  LoginWithPhoneSuccessfullyState(super.loginSuccessfulResponse);
  @override
  List<Object> get props => [loginSuccessfulResponse];
}

class LoginWithGoogleClickedState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class LoginWithGoogleSuccessfullyState extends LoginSuccessfullyState {
  LoginWithGoogleSuccessfullyState(super.loginSuccessfulResponse);
}

class LoginWithAppleSuccessfullyState extends LoginSuccessfullyState {
  LoginWithAppleSuccessfullyState(super.loginSuccessfulResponse);
}

class OpenForgetPasswordScreenState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class OpenSignUpScreenState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SaveTokenDataSuccessfullyState extends LoginState {
  final LoginSuccessfulResponse loginSuccessfulResponse;
  SaveTokenDataSuccessfullyState(this.loginSuccessfulResponse);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class OpenHomeScreenState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ProfileInfoLoadedState extends LoginState {
  final ProfileInfoApiModel profileInfoApiModel;

  ProfileInfoLoadedState(this.profileInfoApiModel);
}

class SaveProfileInfoSuccessfullyState extends LoginState {
  SaveProfileInfoSuccessfullyState();
}
