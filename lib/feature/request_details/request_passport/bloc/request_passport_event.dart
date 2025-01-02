part of 'request_passport_bloc.dart';

sealed class RequestPassportEvent extends Equatable {
  const RequestPassportEvent();

  @override
  List<Object> get props => [];
}

final class UpdateGuestRequestInfoEvent extends RequestPassportEvent {
  final GuestsRequestModel oldData;
  final GuestsRequestModel newData;

  const UpdateGuestRequestInfoEvent(this.oldData, this.newData);

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class UpdateGuestRequestInfoEventV2 extends RequestPassportEvent {
  final PassportRequestModel oldData;
  final PassportRequestModel newData;

  const UpdateGuestRequestInfoEventV2(this.oldData, this.newData);

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class UpdateGuestRequestListApiEvent extends RequestPassportEvent {
  final String requestId;
  final List<GuestsRequestModel> guestList;

  const UpdateGuestRequestListApiEvent(this.requestId, this.guestList);

  @override
  List<Object> get props => [identityHashCode(this)];
}
final class UpdateGuestRequestListApiEventV2 extends RequestPassportEvent {
  final String requestId;
  final List<PassportRequestModel> guestList;

  const UpdateGuestRequestListApiEventV2(this.requestId, this.guestList);

  @override
  List<Object> get props => [identityHashCode(this)];
}
