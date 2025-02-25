import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/plan_details_model.dart';
import 'package:vivas/feature/Community/Data/Models/plan_subscribe_model.dart';
import 'package:vivas/feature/Community/Data/Repository/Plans/PlanDetails/plan_details_repository.dart';

part 'plan_details_event.dart';

part 'plan_details_state.dart';

class PlanDetailsBloc extends Bloc<PlanDetailsEvent, PlanDetailsState> {
  PlanDetailsRepository repository;

  PlanDetailsBloc(this.repository) : super(PlanDetailsInitial()) {
    on<GetPlanDetailsEvent>(_getPlanDetails);
    on<SubscribeEvent>(_subscribePlan);
    on<PaySubscriptionEvent>(_paySubscriptionPlan);
    on<CheckLoggedInEvent>(_checkLoggedIn);
  }

  FutureOr<void> _getPlanDetails(
    GetPlanDetailsEvent event,
    Emitter<PlanDetailsState> emit,
  ) async {
    emit(PlanDetailsLoadingState());
    emit(await repository.getPlanDetails(event.id));
  }

  FutureOr<void> _subscribePlan(
    SubscribeEvent event,
    Emitter<PlanDetailsState> emit,
  ) async {
    emit(PlanDetailsLoadingState());
    emit(await repository.subscribePlan(event.id));
  }

  FutureOr<void> _paySubscriptionPlan(
    PaySubscriptionEvent event,
    Emitter<PlanDetailsState> emit,
  ) async {
    emit(PlanDetailsLoadingState());
    emit(await repository.paySubscriptionPlan(event.model));
  }

  _checkLoggedIn(CheckLoggedInEvent event, Emitter<PlanDetailsState> emit) async {
    emit(await repository.checkLoggedIn());
  }

}
