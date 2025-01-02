part of 'notification_list_bloc.dart';

sealed class NotificationListState extends Equatable {
  const NotificationListState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class NotificationListInitial extends NotificationListState {}

class NotificationListLoadingAsPagingState extends NotificationListState {}

class NotificationListLoadingState extends NotificationListState {}

class NotificationListErrorState extends NotificationListState {
  final String errorMassage;
  final bool isLocalizationKey;
  const NotificationListErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class NotificationListLoadedState extends NotificationListState {
  final List<NotificationItemApiModel> list;
  final MetaModel pagingInfo;

  const NotificationListLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list, pagingInfo];
}

class NotificationReadState extends NotificationListState {
  final NotificationItemApiModel notificationItemApiModel;

  const NotificationReadState(this.notificationItemApiModel);
  @override
  List<Object> get props => [notificationItemApiModel];
}
