part of 'selfie_bloc.dart';

@immutable
sealed class SelfieEvent {}

class SelfieAddImageEvent extends SelfieEvent {
  final XFile? imageP;

  SelfieAddImageEvent(this.imageP);
}

class SelfieAddVerifyImageEvent extends SelfieEvent {
  final XFile? imageP;

  SelfieAddVerifyImageEvent(this.imageP);
}

class SelfieSendingImageEvent extends SelfieEvent {
  final SelfieRequestModel selfieRequestModel;

  SelfieSendingImageEvent(this.selfieRequestModel);
}
