import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/invoice_club_details_model.dart';
import 'package:vivas/feature/Community/Data/Repository/PlanHistory/plan_history_repository.dart';

part 'plan_invoice_details_event.dart';

part 'plan_invoice_details_state.dart';

class PlanInvoiceDetailsBloc
    extends Bloc<PlanInvoiceDetailsEvent, PlanInvoiceDetailsState> {
  PlanHistoryRepository repository;

  PlanInvoiceDetailsBloc(this.repository) : super(PlanInvoiceDetailsInitial()) {
    on<GetPlanTransactionDetails>(_getTransactionDetails);
    on<PlanCheckTermsEvent>(_checkTerms);
    on<PaySubscriptionEvent>(_paySubscriptionPlan);

  }

  _getTransactionDetails(GetPlanTransactionDetails event,
      Emitter<PlanInvoiceDetailsState> emit) async {
    emit(PlanInvoiceDetailsLoading());
    emit(await repository.getDetails(event.id));
  }

  _checkTerms(
      PlanCheckTermsEvent event, Emitter<PlanInvoiceDetailsState> emit) async {
    emit(PlanCheckTerms(event.terms));
  }

  Future<void> _paySubscriptionPlan(
      PaySubscriptionEvent event,
      Emitter<PlanInvoiceDetailsState> emit,
      ) async {
    emit(PlanInvoiceDetailsLoading());
    emit(await repository.paySubscriptionPlan(event.model));
  }
}
