import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Repository/PayRepository/pay_repository.dart';

abstract class PlanHistoryRepository<T, M> extends PayRepository<M> {
  Future<T> getMyHistory(PagingListSendModel model);

  Future<M> getDetails(String planID);
}
