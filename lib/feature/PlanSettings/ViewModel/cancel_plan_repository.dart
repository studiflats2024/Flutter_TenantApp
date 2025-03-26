import 'dart:async';
import 'package:vivas/apis/managers/plan_settings_api_manager.dart';
import 'package:vivas/apis/models/CancelPlan/cancel_plan_model.dart';
import 'package:vivas/feature/PlanSettings/ViewModel/cancel_plans_bloc.dart';

abstract class CancelPlanRepository {
  Future<CancelPlansState> cancelPlan(CancelPlanSendModel reasonModel);
}

class CancelPlanRepositoryImplementation implements CancelPlanRepository {
  final PlanSettingsApiManager planSettingsApiManager;

  CancelPlanRepositoryImplementation(this.planSettingsApiManager);

  @override
  Future<CancelPlansState> cancelPlan(CancelPlanSendModel reasonModel) async {
    CancelPlansState state = CancelPlansInitial();
    await planSettingsApiManager.cancelPlan(reasonModel, (success) {
      state = CancelPlansSuccess();
    }, (fail) {
      state = CancelPlansError(fail);
    });
    return state;
  }
}
