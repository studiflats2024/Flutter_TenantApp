part of 'qr_bloc.dart';

@immutable
sealed class QrState {}

class QrInitial extends QrState {}

class QrLoadingState extends QrState {}

class QrLoadedState extends QrState {
  final List<String> details;
  QrLoadedState(this.details);
}

class OpenDoorLockState extends QrState {
   final String doorLock;
  OpenDoorLockState(this.doorLock);
}

class QrErrorState extends QrState {
  final String errorMassage;
  final bool isLocalizationKey;

  QrErrorState(this.errorMassage, this.isLocalizationKey);
}
