part of 'forget_password_bloc.dart';

abstract class ForgetPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidateFormEvent extends ForgetPasswordEvent {
  final GlobalKey<FormState> userNameFormKey;
  ValidateFormEvent(this.userNameFormKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendRequestOTPEvent extends ForgetPasswordEvent {
  final String userName;
  SendRequestOTPEvent(this.userName);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ResetPasswordApiEvent extends ForgetPasswordEvent {
  final String userName;
  final String token;
  final String password;
  ResetPasswordApiEvent(this.userName, this.token, this.password);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ResetPasswordApiEventV2 extends ForgetPasswordEvent {
  final String userName;
  final String token;
  final String password;
  ResetPasswordApiEventV2(this.userName, this.token, this.password);
  @override
  List<Object> get props => [identityHashCode(this)];
}
