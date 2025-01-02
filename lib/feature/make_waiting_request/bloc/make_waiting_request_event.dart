part of 'make_waiting_request_bloc.dart';

sealed class MakeWaitingRequestEvent extends Equatable {
  const MakeWaitingRequestEvent();

  @override
  List<Object> get props => [];
}

class ValidateFormEvent extends MakeWaitingRequestEvent {
  final GlobalKey<FormState> formKey;
  const ValidateFormEvent(this.formKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SendRequestApiEvent extends MakeWaitingRequestEvent {
  final WaitingRequestUiModel requestUiModel;
  const SendRequestApiEvent(this.requestUiModel);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeNumberOfGuestEvent extends MakeWaitingRequestEvent {
  final int numberOfGuest;
  const ChangeNumberOfGuestEvent(this.numberOfGuest);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeStartDateEvent extends MakeWaitingRequestEvent {
  final DateTime startDate;
  const ChangeStartDateEvent(this.startDate);
  @override
  List<Object> get props => [identityHashCode(this)];
}
