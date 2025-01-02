part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class LoginClickedEventEvent extends SignUpEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ValidateFormEvent extends SignUpEvent {
  final GlobalKey<FormState> signUpFormKey;
  const ValidateFormEvent(this.signUpFormKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SignUpApiEvent extends SignUpEvent {
  final String phoneNumber;
  final String password;
  final String fullName;

  const SignUpApiEvent(this.phoneNumber, this.password, this.fullName);
  @override
  List<Object> get props => [phoneNumber, password, fullName];
}

class SignUpWithGoogleApiEvent extends SignUpEvent {
  final GoogleSignInAccount googleSignInAccount;
  const SignUpWithGoogleApiEvent(this.googleSignInAccount);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SignUpWithAppleEvent extends SignUpEvent {
  final AuthorizationCredentialAppleID appleID;
  const SignUpWithAppleEvent(this.appleID);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SetAsLoggedUserEvent extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class SaveTokenDataEvent extends SignUpEvent {
  final LoginSuccessfulResponse loginSuccessfulResponse;

  const SaveTokenDataEvent(this.loginSuccessfulResponse);
  @override
  List<Object> get props => [loginSuccessfulResponse];
}

class GetUserInfoApiEvent extends SignUpEvent {
  const GetUserInfoApiEvent();
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SaveUserInfoEvent extends SignUpEvent {
  final ProfileInfoApiModel profileInfoApiModel;
  const SaveUserInfoEvent(this.profileInfoApiModel);
  @override
  List<Object> get props => [profileInfoApiModel];
}
