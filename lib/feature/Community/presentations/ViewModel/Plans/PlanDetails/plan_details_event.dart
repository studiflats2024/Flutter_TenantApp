part of 'plan_details_bloc.dart';

@immutable
sealed class PlanDetailsEvent {}

class GetPlanDetailsEvent extends PlanDetailsEvent {
  final String id;

  GetPlanDetailsEvent(this.id);
}

class SubscribeEvent extends PlanDetailsEvent {
  final String id;

  SubscribeEvent(this.id);
}

class PaySubscriptionEvent extends PlanDetailsEvent {
  final PaySubscriptionSendModel model;

  PaySubscriptionEvent(this.model);
}
