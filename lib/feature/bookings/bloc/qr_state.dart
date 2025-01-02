part of 'qr_bloc.dart';

@immutable
sealed class QrState {}

final class QrInitial extends QrState {}

final class QrLoading extends QrState {}

final class QrSuccess extends QrState {}

final class QrWaitingScan extends QrState {}

final class QrSuccessScan extends QrState {}

final class QrFailed extends QrState {
 final String message;
 final bool isLocalizationKey;
 QrFailed(this.message , this.isLocalizationKey);
}
