part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordClickedEvent extends LoginEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SignUpClickedEventEvent extends LoginEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ValidatePhonePasswordEvent extends LoginEvent {
  final GlobalKey<FormState> loginFormKey;
  ValidatePhonePasswordEvent(this.loginFormKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class LoginWithPhonePasswordEvent extends LoginEvent {
  final String email;
  final String password;

  LoginWithPhonePasswordEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogleApiEvent extends LoginEvent {
  final GoogleSignInAccount googleSignInAccount;
  LoginWithGoogleApiEvent(this.googleSignInAccount);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class LoginWithAppleEvent extends LoginEvent {
  final AuthorizationCredentialAppleID appleID;
  LoginWithAppleEvent(this.appleID);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class StartWhatsAppSessionEvent extends LoginEvent {
  StartWhatsAppSessionEvent();
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SetAsLoggedUserEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class SaveTokenDataEvent extends LoginEvent {
  final LoginSuccessfulResponse loginSuccessfulResponse;

  SaveTokenDataEvent(this.loginSuccessfulResponse);
  @override
  List<Object> get props => [loginSuccessfulResponse];
}

class GetUserInfoApiEvent extends LoginEvent {
  GetUserInfoApiEvent();
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SaveUserInfoEvent extends LoginEvent {
  final ProfileInfoApiModel profileInfoApiModel;
  SaveUserInfoEvent(this.profileInfoApiModel);
  @override
  List<Object> get props => [profileInfoApiModel];
}
