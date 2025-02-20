import 'package:vivas/apis/models/meta/paging_send_model.dart';

abstract class PlanHistoryRepository<T> {
  Future<T> getMyHistory(PagingListSendModel model);
  Future<T> getDetails(String planID);
}
