part of 'qr_bloc.dart';

@immutable
sealed class QrEvent {}

class QrQuestionEvent extends QrEvent {}

class QrErrorEvent extends QrEvent {}

class QrSendingEvent extends QrEvent {
  final String bookingId;
  final String bedId;
  final String scannedQr;

  QrSendingEvent(this.bookingId, this.bedId, this.scannedQr);
}

class QrSendingSuccessEvent extends QrEvent {
  final QrRequestModel qrRequestModel;

  QrSendingSuccessEvent(this.qrRequestModel);
}

class QrSendingExceptionEvent extends QrEvent {}
