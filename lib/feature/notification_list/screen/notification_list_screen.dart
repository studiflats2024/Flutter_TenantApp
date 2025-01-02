import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/pagination_manager.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/notification_api_manger.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/notifications_list/notification_item_api_model.dart';
import 'package:vivas/feature/notification_list/widgets/notification_widget.dart';
import 'package:vivas/feature/notification_list/bloc/notification_list_bloc.dart';
import 'package:vivas/feature/notification_list/bloc/notification_list_repository.dart';
import 'package:vivas/feature/widgets/pagination_widgets/paging_swipe_to_refresh_grid_list_widget.dart';
import 'package:vivas/mangers/notification_manger.dart';

import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/no_result/no_result_found.dart';

class NotificationListScreen extends StatelessWidget {
  NotificationListScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/notification-list-screen';

  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationListBloc>(
      create: (context) => NotificationListBloc(NotificationListRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        notificationApiManger: NotificationApiManger(dioApiManager , context),
      )),
      child: const NotificationListScreenWithBloc(),
    );
  }
}

class NotificationListScreenWithBloc extends BaseStatefulScreenWidget {
  const NotificationListScreenWithBloc({super.key});

  @override
  BaseScreenState<NotificationListScreenWithBloc> baseScreenCreateState() {
    return _NotificationListScreenWithBloc();
  }
}

class _NotificationListScreenWithBloc
    extends BaseScreenState<NotificationListScreenWithBloc>
    with PaginationManager<NotificationItemApiModel> {
  late MetaModel _pagingInfo;
  @override
  void initState() {
    _resetPaging();
    Future.microtask(
        () => _getNotificationListApiEvent(isSwipeToRefresh: false));
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.notifications)!),
      ),
      body: BlocListener<NotificationListBloc, NotificationListState>(
        listener: (context, state) {
          if (state is NotificationListLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is NotificationListErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is NotificationListLoadedState) {
            _pagingInfo = state.pagingInfo;
            stopPaginationLoading();
            alignPaginationWithApi(_hasPrevious, _hasNext, state.list);
          } else if (state is NotificationListLoadingAsPagingState) {
            startPaginationLoading();
          } else if (state is NotificationReadState) {
            _openNotification(state.notificationItemApiModel);
          }
        },
        child: _notificationListWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _notificationListWidget() {
    return BlocBuilder<NotificationListBloc, NotificationListState>(
      buildWhen: (previous, current) {
        if (current is NotificationListLoadedState) {
          return true;
        } else if (current is NotificationListLoadingAsPagingState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is NotificationListLoadedState) {
          return _buildListLoaded();
        } else if (state is NotificationListLoadingAsPagingState) {
          return _buildListLoaded();
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  Widget _buildListLoaded() {
    if (getUpdatedData.isEmpty) {
      return _noUnitData();
    }
    return PagingSwipeToRefreshGridListWidget(
      reachedEndOfScroll: () {
        if (shouldLoadMore) {
          startPaginationLoading();

          _getNotificationListApiEvent(isSwipeToRefresh: false);
        }
      },
      itemWidget: (int index) {
        return NotificationWidget(
          cardClickCallback: _notificationClickCallback,
          notificationItemApiModel: getUpdatedData[index],
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getNotificationListApiEvent(isSwipeToRefresh: true);
      },
      listLength: getUpdatedData.length,
      showPagingLoader: currentLoadingState,
    );
  }

  Widget _noUnitData() {
    return PagingSwipeToRefreshGridListWidget(
      reachedEndOfScroll: () {},
      itemWidget: (int index) {
        return NoResultFoundWidget();
      },
      swipedToRefresh: () {
        _resetPaging();
        _getNotificationListApiEvent(isSwipeToRefresh: true);
      },
      listLength: 1,
      showPagingLoader: false,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  NotificationListBloc get currentBloc =>
      BlocProvider.of<NotificationListBloc>(context);

  void _getNotificationListApiEvent({required bool isSwipeToRefresh}) {
    currentBloc.add(GetNotificationListApiEvent(
        _pagingInfo.currentPage + 1, isSwipeToRefresh));
  }

  bool get _hasNext => _pagingInfo.currentPage < _pagingInfo.totalPages;

  bool get _hasPrevious => _pagingInfo.currentPage > 1;

  void _resetPaging() {
    _pagingInfo = MetaModel.getEmptyOne();
    resetPagination();
  }

  Future<void> _notificationClickCallback(
      NotificationItemApiModel model) async {
    currentBloc.add(MarkNotificationReadApiEvent(model));
  }

  Future<void> _openNotification(NotificationItemApiModel model) async {
    NotificationManager()
      ..notificationDataInfo(NotificationData.fromNotificationApiModel(model))
      ..openNotification();
  }
}
