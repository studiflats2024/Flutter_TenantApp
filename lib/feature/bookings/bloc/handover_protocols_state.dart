part of 'handover_protocols_bloc.dart';

@immutable
sealed class HandoverProtocolsState {}

final class HandoverProtocolsInitial extends HandoverProtocolsState {}

final class GetHandoverProtocolsLoading extends HandoverProtocolsState {}

final class GetHandoverProtocolsSuccess extends HandoverProtocolsState {
  final HandoverProtocolsResponseModel model;
  GetHandoverProtocolsSuccess(this.model);
}

final class GetHandoverProtocolsException extends HandoverProtocolsState {
  final String message;
  final bool isLocalizationKey;
  GetHandoverProtocolsException(this.message , this.isLocalizationKey);
}

final class SignHandoverProtocolsLoading extends HandoverProtocolsState {}

final class SignHandoverProtocolsSuccess extends HandoverProtocolsState {
  final SignContractSuccessfullyResponse response;

  SignHandoverProtocolsSuccess(this.response);
}


final class SignHandoverProtocolsException extends HandoverProtocolsState {
  final String message;
  final bool isLocalizationKey;
  SignHandoverProtocolsException(this.message , this.isLocalizationKey);
}