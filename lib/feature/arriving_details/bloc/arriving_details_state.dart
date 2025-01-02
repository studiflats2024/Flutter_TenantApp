part of 'arriving_details_bloc.dart';

@immutable
sealed class ArrivingDetailsState {}

final class ArrivingDetailsInitial extends ArrivingDetailsState {}

final class SendingArrivingDetails extends ArrivingDetailsState {}

final class SendingArrivingDetailsSuccess extends ArrivingDetailsState {}

final class SendingArrivingDetailsLoading extends ArrivingDetailsState {}

final class SendingArrivingDetailsException extends ArrivingDetailsState {}

final class SetArrivingDetailsState extends ArrivingDetailsState {
  final ArrivingDetailsRequestModel arrivingDetailsRequestModel;
  SetArrivingDetailsState(this.arrivingDetailsRequestModel);
}

final class FormValidatedState extends ArrivingDetailsState {}

final class FormNotValidState extends ArrivingDetailsState {}
