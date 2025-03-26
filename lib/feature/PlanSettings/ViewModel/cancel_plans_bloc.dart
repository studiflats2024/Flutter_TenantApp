import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/CancelPlan/cancel_plan_model.dart';
import 'package:vivas/feature/PlanSettings/ViewModel/cancel_plan_repository.dart';

part 'cancel_plans_event.dart';

part 'cancel_plans_state.dart';

class CancelPlansBloc extends Bloc<CancelPlansEvent, CancelPlansState> {
  CancelPlanRepository repository;

  CancelPlansBloc(this.repository) : super(CancelPlansInitial()) {
    on<ChooseCancelPlanReasonEvent>(_chooseCancelPlanReason);
    on<CancelPlanEvent>(_cancelPlanReason);
  }

  _chooseCancelPlanReason(
      ChooseCancelPlanReasonEvent event, Emitter<CancelPlansState> emit) {
    emit(ChooseCancelPlanReasonState(
      event.reason,
    ));
  }

  _cancelPlanReason(
      CancelPlanEvent event, Emitter<CancelPlansState> emit) async {
    emit(CancelPlansLoading());
    emit(await repository.cancelPlan(
      event.reasonModel,
    ));
  }
}
