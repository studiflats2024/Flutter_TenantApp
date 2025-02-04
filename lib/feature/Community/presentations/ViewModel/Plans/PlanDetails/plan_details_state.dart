part of 'plan_details_bloc.dart';

@immutable
sealed class PlanDetailsState {}

final class PlanDetailsInitial extends PlanDetailsState {}

final class PlanDetailsLoadingState extends PlanDetailsState {}

final class GetPlanDetailsState extends PlanDetailsState {
  final PlanDetailsModel planDetailsModel;

  GetPlanDetailsState(this.planDetailsModel);
}

final class SubscribePlanSuccessState extends PlanDetailsState {
  final SubscribePlanModel model;

  SubscribePlanSuccessState(this.model);
}

final class PaySubscribePlanSuccessState extends PlanDetailsState {
  String response;
  PaySubscribePlanSuccessState(this.response);
}

final class ErrorPlanDetails extends PlanDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;

  ErrorPlanDetails(this.errorMassage, this.isLocalizationKey);
}
final class PayErrorPlanDetails extends PlanDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;

  PayErrorPlanDetails(this.errorMassage, this.isLocalizationKey);
}
