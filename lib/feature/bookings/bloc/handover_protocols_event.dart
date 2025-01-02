part of 'handover_protocols_bloc.dart';

@immutable
sealed class HandoverProtocolsEvent {}

class GetHandoverProtocolsEvent extends HandoverProtocolsEvent {
  final HandoverProtocolsRequest handoverProtocolsRequest;

  GetHandoverProtocolsEvent(this.handoverProtocolsRequest);
}

class SignHandoverProtocolsEvent extends HandoverProtocolsEvent{
  final String requestId;
  final String signID;
  final String signatureImagePath;

  SignHandoverProtocolsEvent(this.requestId , this.signID , this.signatureImagePath);
}

