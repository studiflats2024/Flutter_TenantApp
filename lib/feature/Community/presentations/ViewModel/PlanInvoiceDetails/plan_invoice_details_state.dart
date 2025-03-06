part of 'plan_invoice_details_bloc.dart';

@immutable
sealed class PlanInvoiceDetailsState {}

final class PlanInvoiceDetailsInitial extends PlanInvoiceDetailsState {}

final class PlanInvoiceDetailsLoading extends PlanInvoiceDetailsState {}

final class PlanCheckTerms extends PlanInvoiceDetailsState {
  final bool terms;
  PlanCheckTerms(this.terms);

}

class PaySubscribePlanSuccessState extends PlanInvoiceDetailsState {
  final String response;
  PaySubscribePlanSuccessState(this.response);
}

final class GetInvoiceDetails extends PlanInvoiceDetailsState {
  final InvoiceClubDetailsModel model;

  GetInvoiceDetails(this.model);
}

final class ErrorPlanInvoiceState extends PlanInvoiceDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;

  ErrorPlanInvoiceState(this.errorMassage, this.isLocalizationKey);
}