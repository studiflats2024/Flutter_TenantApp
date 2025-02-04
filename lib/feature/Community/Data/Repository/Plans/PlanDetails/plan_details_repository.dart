import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/Plans/PlanDetails/plan_details_bloc.dart';

abstract class PlanDetailsRepository {
  Future<PlanDetailsState> getPlanDetails(String planID);

  Future<PlanDetailsState> subscribePlan(String planID);

  Future<PlanDetailsState> paySubscriptionPlan(PaySubscriptionSendModel model);
}
