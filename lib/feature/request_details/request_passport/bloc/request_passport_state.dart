part of 'request_passport_bloc.dart';

sealed class RequestPassportState extends Equatable {
  const RequestPassportState();

  @override
  List<Object> get props => [];
}

final class RequestPassportInitial extends RequestPassportState {}

class RequestPassportLoadingState extends RequestPassportState {}

class UpdateGuestListSuccessfullyState extends RequestPassportState {
  final String message;
  final DateTime expiredDate;

  const UpdateGuestListSuccessfullyState(this.message, this.expiredDate);
  @override
  List<Object> get props => [message];
}
class UpdateGuestListSuccessfullyStateV2 extends RequestPassportState {
  final String message;

  const UpdateGuestListSuccessfullyStateV2(this.message);
  @override
  List<Object> get props => [message];
}

class RequestPassportErrorState extends RequestPassportState {
  final String errorMassage;
  final bool isLocalizationKey;
  const RequestPassportErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

final class UpdateGuestRequestInfoState extends RequestPassportState {
  final GuestsRequestModel oldData;
  final GuestsRequestModel newData;

  const UpdateGuestRequestInfoState(this.oldData, this.newData);

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class UpdateGuestRequestInfoStateV2 extends RequestPassportState {
  final PassportRequestModel oldData;
  final PassportRequestModel newData;

  const UpdateGuestRequestInfoStateV2(this.oldData, this.newData);

  @override
  List<Object> get props => [identityHashCode(this)];
}
