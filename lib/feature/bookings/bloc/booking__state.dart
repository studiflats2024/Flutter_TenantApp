part of 'booking__bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

class SetEndDateState extends BookingState {
  final DateTime endDate;

  SetEndDateState(this.endDate);
}

class ExtendContractLoadingState extends BookingState {
  ExtendContractLoadingState();
}
class ExtendContractSuccessState extends BookingState {
  ExtendContractSuccessState();
}

class ExtendContractFailedState extends BookingState {
  final ErrorApiModel errorApiModel;

  ExtendContractFailedState(this.errorApiModel);
}
