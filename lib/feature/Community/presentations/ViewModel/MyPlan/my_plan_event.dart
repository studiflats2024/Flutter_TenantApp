part of 'my_plan_bloc.dart';

@immutable
sealed class MyPlanEvent {}

class GetMyPlanEvent extends MyPlanEvent{}

class PaySubscriptionEvent extends MyPlanEvent {
  final PaySubscriptionSendModel model;

  PaySubscriptionEvent(this.model);
}