part of 'cancel_plans_bloc.dart';

@immutable
sealed class CancelPlansState {}

final class CancelPlansInitial extends CancelPlansState {}

final class CancelPlansLoading extends CancelPlansState {}

final class CancelPlansSuccess extends CancelPlansState {}

final class CancelPlansError extends CancelPlansState {
  final ErrorApiModel errorApiModel;

  CancelPlansError(this.errorApiModel);
}

final class ChooseCancelPlanReasonState extends CancelPlansState {
  final int reason;

  ChooseCancelPlanReasonState(this.reason);
}

