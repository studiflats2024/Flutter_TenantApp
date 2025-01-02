part of 'check_in_details_bloc.dart';

abstract class CheckInDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCheckInDetailsEvent extends CheckInDetailsEvent {
  final String requestId;
  GetCheckInDetailsEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
