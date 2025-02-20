import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Repository/PlanHistory/plan_history_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/PlanHistory/plan_history_bloc.dart';

class PlanHistoryRepositoryImplementation
    extends PlanHistoryRepository<PlanHistoryState> {
  CommunityManager communityManager;

  PlanHistoryRepositoryImplementation(this.communityManager);

  @override
  Future<PlanHistoryState> getMyHistory(PagingListSendModel model) async {
    PlanHistoryState state = PlanHistoryInitial();
    await communityManager.planHistoryTransaction(model, (success) {
      state = GetPlanHistory(
        success,
      );
    }, (fail) {
      state = ErrorPlanHistoryState(
        fail.message,
        fail.isMessageLocalizationKey,
      );
    });
    return state;
  }

  @override
  Future<PlanHistoryState> getDetails(String planID)async {
    PlanHistoryState state = PlanHistoryInitial();
    await communityManager.planTransactionDetails(planID, (success) {
      state = GetInvoiceDetails(
        success,
      );
    }, (fail) {
      state = ErrorPlanHistoryState(
        fail.message,
        fail.isMessageLocalizationKey,
      );
    });
    return state;
  }
}
