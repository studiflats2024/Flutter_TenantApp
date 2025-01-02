part of 'notification_list_bloc.dart';

sealed class NotificationListEvent extends Equatable {
  const NotificationListEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationListApiEvent extends NotificationListEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  const GetNotificationListApiEvent(this.pageNumber, this.isSwipeToRefresh);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}

class MarkNotificationReadApiEvent extends NotificationListEvent {
  final NotificationItemApiModel notificationItemApiModel;
  const MarkNotificationReadApiEvent(
    this.notificationItemApiModel,
  );

  @override
  List<Object> get props => [notificationItemApiModel];
}
