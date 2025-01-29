part of 'qr_bloc.dart';

@immutable
sealed class QrState {}

final class QrInitial extends QrState {}

final class QrLoadingState extends QrState {}

final class QrLoadedState extends QrState {
  List<String> details;
  QrLoadedState(this.details);
}

final class QrErrorState extends QrState {
  final String errorMassage;
  final bool isLocalizationKey;

  QrErrorState(this.errorMassage, this.isLocalizationKey);
}
