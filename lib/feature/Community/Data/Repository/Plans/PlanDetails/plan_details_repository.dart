import 'package:vivas/feature/Community/Data/Repository/PayRepository/pay_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/Plans/PlanDetails/plan_details_bloc.dart';

abstract class PlanDetailsRepository  extends PayRepository<PlanDetailsState>{
  Future<PlanDetailsState> getPlanDetails(String planID);

  Future<PlanDetailsState> subscribePlan(String planID);

  Future<PlanDetailsState> checkLoggedIn();
  // Future<PlanDetailsState> paySubscriptionPlan(PaySubscriptionSendModel model);
}
