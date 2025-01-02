part of 'make_request_bloc.dart';

sealed class MakeRequestState extends Equatable {
  const MakeRequestState();

  @override
  List<Object> get props => [];
}

final class MakeRequestInitial extends MakeRequestState {}

class MakeRequestLoadingState extends MakeRequestState {}

class MakeRequestErrorState extends MakeRequestState {
  final String errorMassage;
  final bool isLocalizationKey;
  const MakeRequestErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class FormValidatedState extends MakeRequestState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class FormNotValidatedState extends MakeRequestState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeNumberOfGuestState extends MakeRequestState {
  final int numberOfGuests;

  const ChangeNumberOfGuestState(this.numberOfGuests);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeWhereStay extends MakeRequestState {
  final RequestUiModel requestUiModel;

  const ChangeWhereStay(this.requestUiModel);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SetDataOnRequest extends MakeRequestState {
  final RequestUiModel requestUiModel;

  const SetDataOnRequest(this.requestUiModel);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class OnSelectedState extends MakeRequestState {
  const OnSelectedState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class OnSelectedRoomState extends MakeRequestState {
  const OnSelectedRoomState();

  @override
  List<Object> get props => [identityHashCode(this)];
}
class OnSelectedBedState extends MakeRequestState {
  const OnSelectedBedState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class StartDateChangedState extends MakeRequestState {
  final DateTime startDate;

  const StartDateChangedState(this.startDate);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendRequestSuccessfullyState extends MakeRequestState {
  final String message;
  final String requestId;

  const SendRequestSuccessfullyState(this.message, this.requestId);
  @override
  List<Object> get props => [identityHashCode(this)];
}
