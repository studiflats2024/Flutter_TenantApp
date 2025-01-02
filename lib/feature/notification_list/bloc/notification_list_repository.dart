import 'package:vivas/apis/managers/notification_api_manger.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/apis/models/notifications_list/notification_item_api_model.dart';
import 'package:vivas/feature/notification_list/bloc/notification_list_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseNotificationListRepository {
  Future<NotificationListState> getNotificationListApi(int pageNumber);
  Future<NotificationListState> markNotificationReadApi(
      NotificationItemApiModel notificationItemApiModel);
}

class NotificationListRepository implements BaseNotificationListRepository {
  final PreferencesManager preferencesManager;
  final NotificationApiManger notificationApiManger;

  NotificationListRepository({
    required this.preferencesManager,
    required this.notificationApiManger,
  });

  @override
  Future<NotificationListState> getNotificationListApi(int pageNumber) async {
    late NotificationListState notificationListState;
    await notificationApiManger.getNotificationListApi(
        PagingListSendModel(pageNumber: pageNumber), (apartmentListWrapper) {
      notificationListState = NotificationListLoadedState(
          apartmentListWrapper.data, apartmentListWrapper.pagingInfo);
    }, (errorApiModel) {
      notificationListState = NotificationListErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return notificationListState;
  }

  @override
  Future<NotificationListState> markNotificationReadApi(
      NotificationItemApiModel notificationItemApiModel) async {
    late NotificationListState notificationListState;
    await notificationApiManger
        .markNotificationReadApi(notificationItemApiModel.notificationId, () {
      notificationListState = NotificationReadState(notificationItemApiModel);
    }, (errorApiModel) {
      notificationListState = NotificationReadState(notificationItemApiModel);
    });

    return notificationListState;
  }
}
