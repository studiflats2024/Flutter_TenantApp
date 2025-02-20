part of 'plan_history_bloc.dart';

@immutable
sealed class PlanHistoryEvent {}

class GetPlanTransactions extends PlanHistoryEvent {
  final PagingListSendModel model;

  GetPlanTransactions(this.model);
}

class GetPlanTransactionDetails extends PlanHistoryEvent {
  final String id;

  GetPlanTransactionDetails(this.id);
}
