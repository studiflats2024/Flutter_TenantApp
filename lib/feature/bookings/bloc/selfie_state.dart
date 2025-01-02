part of 'selfie_bloc.dart';

@immutable
sealed class SelfieState {}

class SelfieInitial extends SelfieState {}

class SelfieSendingLoading extends SelfieState {}

class SelfieSendingSuccess extends SelfieState {}

class SelfieSendingException extends SelfieState {
  final String message;
  final bool isLocalizationKey;

  SelfieSendingException(this.message, this.isLocalizationKey);
}

class SelfieAddImage extends SelfieState {
  final XFile? imageP;

   SelfieAddImage(this.imageP);
}

class SelfieAddVerifiedImage extends SelfieState {
  final XFile? imageP;

  SelfieAddVerifiedImage(this.imageP);
}
