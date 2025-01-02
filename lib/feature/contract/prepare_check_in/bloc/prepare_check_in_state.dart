part of 'prepare_check_in_bloc.dart';

abstract class PrepareCheckInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckInInitial extends PrepareCheckInState {}

class CheckInLoadingState extends PrepareCheckInState {}

class CheckInErrorState extends PrepareCheckInState {
  final String errorMassage;
  final bool isLocalizationKey;
  CheckInErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class FormValidatedState extends PrepareCheckInState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class FormNotValidatedState extends PrepareCheckInState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class ServiceOptionChangedState extends PrepareCheckInState {
  final bool isYesOptionSelected;
  ServiceOptionChangedState(this.isYesOptionSelected);
  @override
  List<Object> get props => [isYesOptionSelected];
}

class CheckInSuccessfullyState extends PrepareCheckInState {
  final PrepareCheckInSuccessfullyResponse response;
  CheckInSuccessfullyState(this.response);

  @override
  List<Object?> get props => [response];
}
