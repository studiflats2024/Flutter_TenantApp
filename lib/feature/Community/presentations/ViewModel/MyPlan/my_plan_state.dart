part of 'my_plan_bloc.dart';

@immutable
sealed class MyPlanState {}

class MyPlanInitial extends MyPlanState {}

class MyPlanLoadingState extends MyPlanState {}

class GetMyPlanState extends MyPlanState {
  final MyPlanModel? model;

  GetMyPlanState(this.model);
}

class PaySubscribePlanSuccessState extends MyPlanState {
  final String response;
  PaySubscribePlanSuccessState(this.response);
}

class ErrorMyPlanState extends MyPlanState {
  final String errorMassage;
  final bool isLocalizationKey;

  ErrorMyPlanState(this.errorMassage, this.isLocalizationKey);
}
