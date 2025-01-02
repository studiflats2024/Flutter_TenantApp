part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class ValidateOTPEvent extends OtpEvent {
  final GlobalKey<FormState> otpFormKey;
  const ValidateOTPEvent(this.otpFormKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendRequestOTPAgainEvent extends OtpEvent {
  final String uuid;
  const SendRequestOTPAgainEvent(this.uuid);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CheckOTPWithApiEvent extends OtpEvent {
  final String otpCode;
  final String uuid;
  const CheckOTPWithApiEvent(this.uuid, this.otpCode);
  @override
  List<Object> get props => [identityHashCode(this)];
}
