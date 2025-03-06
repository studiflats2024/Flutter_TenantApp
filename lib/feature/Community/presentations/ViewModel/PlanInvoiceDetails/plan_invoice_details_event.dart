part of 'plan_invoice_details_bloc.dart';

@immutable
sealed class PlanInvoiceDetailsEvent {}

class GetPlanTransactionDetails extends PlanInvoiceDetailsEvent {
  final String id;

  GetPlanTransactionDetails(this.id);
}


final class PlanCheckTermsEvent extends PlanInvoiceDetailsEvent {
  final bool terms;
  PlanCheckTermsEvent(this.terms);

}

class PaySubscriptionEvent extends PlanInvoiceDetailsEvent {
  final PaySubscriptionSendModel model;

  PaySubscriptionEvent(this.model);
}

