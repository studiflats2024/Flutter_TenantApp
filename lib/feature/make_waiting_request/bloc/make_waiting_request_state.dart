part of 'make_waiting_request_bloc.dart';

sealed class MakeWaitingRequestState extends Equatable {
  const MakeWaitingRequestState();

  @override
  List<Object> get props => [];
}

final class MakeWaitingRequestInitial extends MakeWaitingRequestState {}

class MakeWaitingRequestLoadingState extends MakeWaitingRequestState {}

class MakeWaitingRequestErrorState extends MakeWaitingRequestState {
  final String errorMassage;
  final bool isLocalizationKey;
  const MakeWaitingRequestErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class FormValidatedState extends MakeWaitingRequestState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class FormNotValidatedState extends MakeWaitingRequestState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeNumberOfGuestState extends MakeWaitingRequestState {
  final int numberOfGuests;

  const ChangeNumberOfGuestState(this.numberOfGuests);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class StartDateChangedState extends MakeWaitingRequestState {
  final DateTime startDate;
  const StartDateChangedState(this.startDate);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendRequestSuccessfullyState extends MakeWaitingRequestState {
  final String message;

  const SendRequestSuccessfullyState(this.message);
  @override
  List<Object> get props => [identityHashCode(this)];
}
