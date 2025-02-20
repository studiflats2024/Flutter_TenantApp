part of 'plan_history_bloc.dart';

@immutable
sealed class PlanHistoryState {}

final class PlanHistoryInitial extends PlanHistoryState {}

final class PlanHistoryLoading extends PlanHistoryState {}

final class GetPlanHistory extends PlanHistoryState {
  final PlanHistoryModel planHistoryModel;

  GetPlanHistory(this.planHistoryModel);
}

final class GetInvoiceDetails extends PlanHistoryState {
  final InvoiceClubDetailsModel model;

  GetInvoiceDetails(this.model);
}

final class ErrorPlanHistoryState extends PlanHistoryState {
  final String errorMassage;
  final bool isLocalizationKey;

  ErrorPlanHistoryState(this.errorMassage, this.isLocalizationKey);
}
