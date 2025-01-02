part of 'prepare_check_in_bloc.dart';

abstract class PrepareCheckInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendCheckInEvent extends PrepareCheckInEvent {
  final PrepareCheckInSendModel data;
  SendCheckInEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class ValidateFormEvent extends PrepareCheckInEvent {
  final GlobalKey<FormState> formKey;
  ValidateFormEvent(this.formKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeServiceOptionEvent extends PrepareCheckInEvent {
  final bool isYesOptionSelected;
  ChangeServiceOptionEvent(this.isYesOptionSelected);
  @override
  List<Object> get props => [isYesOptionSelected];
}
