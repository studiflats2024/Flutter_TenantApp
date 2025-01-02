part of 'booking__bloc.dart';

@immutable
sealed class BookingEvent {}

class SetEndDateEvent extends BookingEvent{
  final DateTime endDate;
  SetEndDateEvent(this.endDate);
}

class ExtendContractEvent extends BookingEvent{
  final ExtendContractModel extendContractModel ;
  ExtendContractEvent(this.extendContractModel);
}