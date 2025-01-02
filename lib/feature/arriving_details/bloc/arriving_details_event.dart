part of 'arriving_details_bloc.dart';

@immutable
sealed class ArrivingDetailsEvent {}

class SendArrivingDetailsEvent extends ArrivingDetailsEvent {
  final ArrivingDetailsRequestModel arrivingDetailsRequestModel;

  SendArrivingDetailsEvent(this.arrivingDetailsRequestModel);
}

class ValidateFormEvent extends ArrivingDetailsEvent {
  final GlobalKey<FormState> requestFormKey;

  ValidateFormEvent(this.requestFormKey);
}

class SetArrivingDetailsEvent extends ArrivingDetailsEvent {
  final ArrivingDetailsRequestModel arrivingDetailsRequestModel;

  SetArrivingDetailsEvent(this.arrivingDetailsRequestModel);
}
