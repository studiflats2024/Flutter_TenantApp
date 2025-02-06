part of 'qr_bloc.dart';

@immutable
sealed class QrEvent {}

class GetQrDetails extends QrEvent {}

class GetDoorLock extends QrEvent {}
