part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoadingState extends OtpState {}

class OtpErrorState extends OtpState {
  final String errorMassage;
  final bool isLocalizationKey;

  const OtpErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class OTPValidatedState extends OtpState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class OTPNotValidatedState extends OtpState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class RequestOTPAgainApiSuccessfullyState extends OtpState {
  final String message;
  const RequestOTPAgainApiSuccessfullyState(this.message);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CheckOTPApiSuccessfullyState extends OtpState {
  final String message;

  const CheckOTPApiSuccessfullyState(this.message);

  @override
  List<Object> get props => [identityHashCode(this)];
}
