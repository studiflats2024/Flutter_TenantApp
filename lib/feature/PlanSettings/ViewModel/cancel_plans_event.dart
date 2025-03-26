part of 'cancel_plans_bloc.dart';

@immutable
sealed class CancelPlansEvent {}

class ChooseCancelPlanReasonEvent extends CancelPlansEvent {
  final int reason;

  ChooseCancelPlanReasonEvent(this.reason);
}

class CancelPlanEvent extends CancelPlansEvent {
  final CancelPlanSendModel reasonModel;

  CancelPlanEvent(this.reasonModel);
}
