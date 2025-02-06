import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_plan_model.dart';
import 'package:vivas/feature/Community/Data/Repository/MyPlan/my_plan_repository.dart';

part 'my_plan_event.dart';

part 'my_plan_state.dart';

class MyPlanBloc extends Bloc<MyPlanEvent, MyPlanState> {
  MyPlanRepository repository;

  MyPlanBloc(this.repository) : super(MyPlanInitial()) {
    on<GetMyPlanEvent>(_getMyPlan);
    on<PaySubscriptionEvent>(_paySubscriptionPlan);
  }

  Future<void> _getMyPlan(
      GetMyPlanEvent event, Emitter<MyPlanState> emit) async {
    emit(MyPlanLoadingState());
    emit(await repository.getMyPlan());
  }

  Future<void> _paySubscriptionPlan(
    PaySubscriptionEvent event,
    Emitter<MyPlanState> emit,
  ) async {
    emit(MyPlanLoadingState());
    emit(await repository.paySubscriptionPlan(event.model));
  }
}
