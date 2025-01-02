import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/notifications_list/notification_item_api_model.dart';
import 'package:vivas/feature/notification_list/bloc/notification_list_repository.dart';

part 'notification_list_event.dart';
part 'notification_list_state.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  final BaseNotificationListRepository notificationListRepository;
  NotificationListBloc(this.notificationListRepository)
      : super(NotificationListInitial()) {
    on<GetNotificationListApiEvent>(_getNotificationListApiEvent);
    on<MarkNotificationReadApiEvent>(_markNotificationReadApiEvent);
  }

  FutureOr<void> _getNotificationListApiEvent(GetNotificationListApiEvent event,
      Emitter<NotificationListState> emit) async {
    emit(NotificationListLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? NotificationListLoadingState()
          : NotificationListLoadingAsPagingState());
    }
    emit(await notificationListRepository
        .getNotificationListApi(event.pageNumber));
  }

  FutureOr<void> _markNotificationReadApiEvent(
      MarkNotificationReadApiEvent event,
      Emitter<NotificationListState> emit) async {
    emit(NotificationListLoadingState());
    emit(await notificationListRepository
        .markNotificationReadApi(event.notificationItemApiModel));
  }
}
