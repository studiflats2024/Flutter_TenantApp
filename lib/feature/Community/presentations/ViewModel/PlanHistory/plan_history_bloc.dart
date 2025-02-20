import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/invoice_club_details_model.dart';
import 'package:vivas/feature/Community/Data/Models/plan_history_model.dart';
import 'package:vivas/feature/Community/Data/Repository/PlanHistory/plan_history_repository.dart';

part 'plan_history_event.dart';

part 'plan_history_state.dart';

class PlanHistoryBloc extends Bloc<PlanHistoryEvent, PlanHistoryState> {
  PlanHistoryRepository repository;

  PlanHistoryBloc(this.repository) : super(PlanHistoryInitial()) {
    on<GetPlanTransactions>(_getTransaction);
    on<GetPlanTransactionDetails>(_getTransactionDetails);
  }

  _getTransaction(
      GetPlanTransactions event, Emitter<PlanHistoryState> emit) async {
    emit(PlanHistoryLoading());
    emit(await repository.getMyHistory(event.model));
  }

  _getTransactionDetails(
      GetPlanTransactionDetails event, Emitter<PlanHistoryState> emit) async {
    emit(PlanHistoryLoading());
    emit(await repository.getDetails(event.id));
  }
}
