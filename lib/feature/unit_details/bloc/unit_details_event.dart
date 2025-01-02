part of 'unit_details_bloc.dart';

sealed class UnitDetailsEvent extends Equatable {
  const UnitDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetUnitDetailsApiEvent extends UnitDetailsEvent {
  final String uuid;
  const GetUnitDetailsApiEvent(this.uuid);

  @override
  List<Object> get props => [];
}

class GetFaqApiEvent extends UnitDetailsEvent {
  const GetFaqApiEvent();

  @override
  List<Object> get props => [];
}

class CheckIsLoggedInEvent extends UnitDetailsEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}