part of 'forget_password_bloc.dart';

abstract class ForgetPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoadingState extends ForgetPasswordState {}

class ForgetPasswordErrorState extends ForgetPasswordState {
  final String errorMassage;
  final bool isLocalizationKey;

  ForgetPasswordErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class FormValidatedState extends ForgetPasswordState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class FormNotValidatedState extends ForgetPasswordState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class RequestOTPApiSuccessfullyState extends ForgetPasswordState {
  final ForgetPasswordSuccessfulResponse forgetPasswordSuccessfulResponse;
  RequestOTPApiSuccessfullyState(this.forgetPasswordSuccessfulResponse);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class ResetPasswordApiSuccessfullyState extends ForgetPasswordState {
  final String message;
  ResetPasswordApiSuccessfullyState(this.message);

  @override
  List<Object> get props => [identityHashCode(this)];
}
